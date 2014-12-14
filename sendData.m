function sendable = sendData(datafile,rate)
%Start up the Daq

s = daq.createSession('digilent')
s.DurationInSeconds =120;
%This is W1. 
ch = addAnalogOutputChannel(s,'AD1', 1, 'Voltage')

%Get the rate
s.Rate = rate;

%define header
header = [1 0 1 0 1 0 1 0];
%length without header
packetlen = 128;
%For now, just read in all at once. 
data = csvread(datafile);
%Scale appropriately
data = 10*data-5;
%Number of packets
numpackets = ceil(length(data)/packetlen);

%% Transmit once

% for i = 1:numpackets
%     startind = packetlen*(i -1) + 1;
%     if (i == numpackets)
%         datatotransmit = horzcat(header,data(startind:end))';
%     else
%         endind = startind + (packetlen - 1);
%         datatotransmit = horzcat(header,data(startind:endind))';
%     end
%     
%     queueOutputData(s,datatotransmit);
%     s.startForeground;
%   
% end


%% Transmit Continuously

% iteration = 0;
% while true
%     iteration = iteration +1;
%     i = mod(iteration, numpackets) + 1;
%     startind = packetlen*(i -1) + 1;
%     if (i == numpackets)
%         datatotransmit = horzcat(header,data(startind:end))';
%     else
%         endind = startind + (packetlen - 1);
%         datatotransmit = horzcat(header,data(startind:endind))';
%     end
%     
%     queueOutputData(s,datatotransmit);
%     s.startForeground;
%   
% end

%% Return on completion
sendable = 1;

end