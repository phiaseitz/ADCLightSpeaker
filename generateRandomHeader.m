function generateRandomHeader(length)
    
    randomData = randi([0 1], length, 1);
    
    save('random_header', 'randomData');
end