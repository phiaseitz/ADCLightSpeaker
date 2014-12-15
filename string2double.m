function [message_vector] = string2double(message)
bin_vector = dec2bin(message)';
chars = bin_vector(:)';
message_vector = str2num(chars(:));
return



