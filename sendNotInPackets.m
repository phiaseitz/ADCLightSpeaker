function sendable = sendNotInPackets(data,rate)
%Start up the Daq

DAQ = daq.createSession('digilent')
DAQ.DurationInSeconds =120;
%This is W1. 
DAQ.addAnalogOutputChannel('AD1', 1, 'Voltage')
% Turn on power supplies
DAQ.setPowerSupply('positive','on');
DAQ.setPowerSupply('negative','on');

%Set the rate
DAQ.Rate = rate;

%define header
header = [1; 0; 1; 0; 1; 0; 1; 0];

%For now, just read in all at once. To send from CSV uncomment
%data = csvread(datafile);
%Scale appropriately
data = 10*data-5;


%% Transmit once

datatotransmit = vertcat(header,data);

queueOutputData(DAQ,datatotransmit);

DAQ.startForeground;


%% Return on completion
sendable = 1;

end