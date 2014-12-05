%x = dec2bin('engineering')
%y = reshape(x',1,numel(x))
%char(bin2dec(reshape(y,7,[]).')).'

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

clear;
clf;

%load test2.mat    %comment out if receiving actual data

threshold = 4;

%Creates session
s = daq.createSession('digilent');
ch = addAnalogInputChannel(s, 'AD1', 1, 'Voltage');

%2 orders of magnitude higher than transfer rate
s.Rate = 500;
s.Channels.Range = [0 5];
s.DurationInSeconds = 30;

%Reads data
[singleReading, triggerTime] = s.inputSingleScan;
[data, timestamps, triggerTime] = s.startForeground;

plot(timestamps, data);
xlabel('Time (seconds)')
ylabel('Voltage (Volts)')
title(['Clocked Data Triggered on: ' datestr(triggerTime)])

%hardcoded: 00 1 0 1 1 0
%data = [0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0,5,5,5,5,5,5,5,5,5,5,0,0,0,0,0,5,5,5,5,5,0,0,0,0,0];%,5,5,5,5,5,0,0,0,0,0];

%search for first instance of data being > threshold -- that is the first 1
first = find(data>threshold, 1);
trunc_data = data(first:end);
%trunc_data = data(first:s.Rate:end);

%make binary version of data
figure;
high_indices1 = find(trunc_data>threshold);   %find all high indices
data_binary = zeros(size(trunc_data));        %initialize as zero
data_binary(high_indices1) = 1;         %set all high bits to 1

area(data_binary);
ylabel('Binary Data');


%first row: 1 or 0?
%second row: for how long?

%count how long the data has been 1 or 0.
count = 0;
%where are we in the high_low vector?
col_count = 1;
for i=1:size(data_binary)-1
    current = data_binary(i);
    next = data_binary(i+1);
    if(current == next)
        count = count + 1;
    else
        high_low(2, col_count) = count;
        high_low(1, col_count) = current;
        count = 0;
        col_count = col_count + 1;
    end
end
high_low(2, col_count) = count;
high_low(1, col_count) = current;

%the first element is a single bit. Measure its length and assume it is
%the size of a single bit. (could average it in the future?)
%now with 8 bits!
bitlen = sum(high_low(2,1:8))/8;
%bitlen = 13;

%keep array full of "bit numbers" i.e. how many bits in a row
num_bits = high_low(:,9:end);     %removing first junk byte!
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


str_bitstr = num2str(bitstring);
str_bitstr(isspace(str_bitstr)) = '';
[strrow, strcol] = size(str_bitstr);
endbits = mod(strcol, 7);   %number of bits in char
str_bitstr = str_bitstr(1:strcol-endbits);
%str_bitstr = str_bitstr(1,1:21);
%str_bitstr = bin2dec(str_bitstr);
char(bin2dec(reshape(str_bitstr,7,[]).')).'

