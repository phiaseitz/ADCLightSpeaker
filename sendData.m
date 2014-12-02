function[sendable] = sendData(rate, frequency, data)
%NOTE: not actually tested yet -- this might require some debugging
%Create daq session
s = daq.createSession('digilent')
s.DurationInSeconds =120;
%This is W1. 
ch = addAnalogOutputChannel(s,'AD1', 1, 'Voltage')

%Get the rate
s.Rate = rate;

%How many copies of the same number we need
numcopies = rate/frequency;

%Make that many copies of data
tiled = repmat(data,numcopies);

%concatenate column after column
outdata = reshape(tiled', 1,numel(data))

%Eventually we'll concatenate the outdata with a header here
output = outdata;
sendable = str2double(cellstr(output'))'


% onesarray = 5*ones(rate,1);
% zerosarray = zeros(rate,1);
% 
% output = cat(1,onesarray,zerosarray);


%Transmit through the Analog Discovery
queueOutputData(s,output);
s.startForeground;
end