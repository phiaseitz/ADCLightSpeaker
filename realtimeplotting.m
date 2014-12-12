function realtimeplotting()
tic
s = daq.createSession('digilent')
%This is 1+.
s.addAnalogInputChannel('AD1', 1, 'Voltage')

s.DurationInSeconds =120;
s.Rate = 200e3;
s.DurationInSeconds = 15;

lh = s.addlistener('DataAvailable', @plotData);

s.startBackground();

while (~s.IsDone)
end 

%plot(data)

    function plotData(scr, event)
        toc
        persistent tempData;
        persistent tempTimeStamps;
        if(isempty(tempData))
            tempData = []
           
         tempTimeStamps = [];
        end
     tempData = [tempData;event.Data];
     tempTimeStamps = [tempTimeStamps; event.TimeStamps];
     plot(tempTimeStamps,tempData);
    end
end