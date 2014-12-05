function[error_rate] = errorcheck(sent, received)
    message_nums = str2double(cellstr(received'))';
    errors = message_nums(1:size(sent,2)) - sent;
    error_rate = sum(abs(errors))/size(sent,2);



