function[tosend] = send_text(text)
    %Create header of all zeros and then alternating bits
    allzeros = zeros(1,8);
    header = [1 0 1 0 1 0 1 0];
    predata = cat(2,allzeros, header);
    %Make data into string
    predatastr = int2str(predata);
    %Get rid of all the spaces
    predatastr = regexprep(predatastr,'[^\w]','')
    %Convert text to binary
    data = dec2bin(text);
    %Reshape
    dataarray = reshape(data',1,numel(data));
    %Concatenate predata and data
    tosend = cat(2,predatastr, dataarray)
    
    %write to a csv
    csvwrite('csvs/sendit.csv', tosend);
end