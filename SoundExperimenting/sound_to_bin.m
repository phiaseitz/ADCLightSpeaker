function soundbin = sound_to_bin()
    [song,fs] = audioread('song.wav');
    soundbin = dec2bin( typecast( single(song(:)), 'uint8'), 8 ) - '0';

end