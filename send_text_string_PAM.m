function [transmitted,binary] = send_text_string_PAM(text,rate)
%Start up the Daq
samplesperbit =4;
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
 header = [5; 0; 5; 0; 5; 0; 5; 0];

%For now, just read in all at once. To send from CSV uncomment
%data = csvread(datafile);

%get binary version of text
binary = string2double(text);

%% Transmit once

%convert to pam values
datatotransmit = bin_to_PAM(binary)

%Scale
datatotransmit = 5/(max(datatotransmit))*datatotransmit;
%Add in header
datatotransmit = vertcat(header,datatotransmit);

%Upsample the data
dataup = upsample(datatotransmit,4);
dataupoff = upsample(datatotransmit,4,1);
dataupoffagain = upsample(datatotransmit,4,2);
dataupoffagainagain = upsample(datatotransmit,4,3);
datatotransmit = dataup + dataupoff + dataupoffagain + dataupoffagainagain;


queueOutputData(DAQ,datatotransmit);

DAQ.startForeground;


%% Return on completion
transmitted = datatotransmit;

end