function [message_vector] = string2double(message)
%Convert string to binary. (Each character
%can be thought of as a number)
bin_vector = dec2bin(message)';
%Transpose the vector
chars = bin_vector(:)';
%Convert the binary string of 1s and 0s
message_vector = str2num(chars(:));
end



