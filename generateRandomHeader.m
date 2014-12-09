function res = generateRandomHeader(length)
    header = randi([0 1], length, 1);
    save('random_header', 'header');
    res = header;
end