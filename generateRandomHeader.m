function res = generateRandomHeader(length)
    header = [1; 0; 1; 0; 1; 0; 1; 0];
    
    randomData = randi([0 1], length, 1);
    
    randomData = vertcat(header, randomData);
    
    save('random_header', 'randomData');
    res = header;
end