function sendable = sendNotInPackets(data,rate)
%Start up the Daq
samplesperbit = 2;
DAQ = daq.createSession('digilent')
DAQ.DurationInSeconds =5;
%This is W1. 
DAQ.addAnalogOutputChannel('AD1', 1, 'Voltage')
% Turn on power supplies
DAQ.setPowerSupply('positive','on');
DAQ.setPowerSupply('negative','on');

%Set the rate
DAQ.Rate = samplesperbit*rate;

%define header
%header = [1; 0; 1; 0; 1; 0; 1; 0];

%For now, just read in all at once. To send from CSV uncomment
%data = csvread(datafile);

%% Transmit once
%datatotransmit = vertcat(header,data);
dataup = upsample(data,2);
dataupoff = upsample(data,2,1);
datatotransmit = dataup + dataupoff;

% Scale
datatotransmit = 10*datatotransmit - 5;


queueOutputData(DAQ,datatotransmit);

DAQ.startForeground;


%% Return on completion
sendable = 1;

end