%TODO 12/11/2014: try audio amp again
%Common errors:
%have you powered the receive circuit? Is Analog Discovery power on?
%have you set it to run continuously?
%have you commented out everything you should?
%is the sample rate appropriate? No, really... is it?
%"Undefined function or variable 'current'." -- is everything powered?
%That usually means the data is all zeros. Give it enough time to
%warm up! That means 3 seconds at least.
%Warning: Requested sampling rate is too high. Device buffer is being filled faster than it is
%being emptied. A lower acquisition rate is recommended.
close all;
clear;
clf;
%load test2.mat %comment out if receiving actual data
%fread for reading raw binary data
%fopen, fclose
%account for header in data rate calculation!!!
%more gain could be useful
%focus on distance
%send in smaller packets -- send zeros in between packets
%Threshold for "what is a 0 vs. a 1?" at various distances
%100 mV @ 0 distance
%75 mV @ 1 cm
%15 mV @ 2 cm
%centered photodiode on LEDs now! May need to recollect data
%20 mV @ 3 cm
%threshold = 100e-3;


threshold = 125e-3; %threshold no longer depends on distance b/c LEDS
%are turning off fully now


%Creates session
s = daq.createSession('digilent');
ch = addAnalogInputChannel(s, 'AD1', 1, 'Voltage');
s.setPowerSupply('positive', 'on');
s.setPowerSupply('negative', 'on');
%Bit rate, in Hz
dataRate =50000;



%At least 4 samples per bit is a good idea at 0 distance
%10 samples per second @ 50 kHz seems to work, even though we get
%throttling. Perhaps it's throttling afterward?
bit_samples = 10; %samples per bit.
%Set to 4 up to 60k
%Set to 6 @ 70k
%Set to 6 @ 80k -- note that throttling happens but we still get right
%data. May be problem for sound?


%set up channel
s.Rate = bit_samples*dataRate;
s.Channels.Range = [0 5];
s.DurationInSeconds = 3;
%Reads data
[singleReading, triggerTime] = s.inputSingleScan;
[data, timestamps, triggerTime] = s.startForeground;


%plot of raw data
plot(timestamps, data);
xlabel('Time (seconds)')
ylabel('Voltage (Volts)')
title(['Clocked Data Triggered on: ' datestr(triggerTime)])


%search for first instance of data being > threshold -- that is the first 1
%in the header
first = find(data>threshold, 1);
trunc_data = data(first:end);


%make binary version of data

figure;
high_indices1 = find(trunc_data>threshold); %find all high indices
data_binary = zeros(size(trunc_data)); %initialize as zero
data_binary(high_indices1) = 1; %set all high bits to 1


%plot of binary data
area(data_binary);
ylabel('Binary Data');



%count how long the data has been 1 or 0.
count = 0;
%zero_count = 0;
zero_threshold = bit_samples*12;
%where are we in the high_low vector?
col_count = 1;

for i=1:size(data_binary)-1
current = data_binary(i);
next = data_binary(i+1);

    if(current == next)
        count = count + 1;
        if(current == 0 && count == zero_threshold)
            break;
        end
    else
        high_low(2, col_count) = count;
        high_low(1, col_count) = current;
        count = 0;
        col_count = col_count + 1;
    end
end


high_low(2, col_count) = count;
high_low(1, col_count) = current;
%how many samples are in a bit?
bitlen = (s.Rate/dataRate);


%keep array full of "bit numbers" i.e. how many bits in a row
num_bits = high_low(:,9:end); %removing first junk byte!
num_bits(2,:) = num_bits(2,:)/bitlen;
num_bits = round(num_bits);


high_low;
num_bits;
bitstring = [];

[row, col] = size(num_bits);

for i=1:col
%number of bits in a row
    bits = num_bits(2,i);
    for j=1:bits
    bitstring = [bitstring num_bits(1,i)];
    end
end

%very time intensive
str_bitstr = num2str(bitstring);
str_bitstr(isspace(str_bitstr)) = '';
[strrow, strcol] = size(str_bitstr);
endbits = mod(strcol, 7); %number of bits in char
str_bitstr = str_bitstr(1:strcol-endbits);
%str_bitstr = str_bitstr(1,1:21);
%str_bitstr = bin2dec(str_bitstr);
char(bin2dec(reshape(str_bitstr,7,[]).')).'