function bin_sound()
%Comment out this next line once we have the right stuff)
fs = 44100;
song = sound_to_bin();
disp('loaded')
binsize = size(song);
reshapesize = [binsize(1)/4,1];
song = reshape( typecast( uint8(bin2dec( char(song + '0') )), 'single' ), reshapesize );
sound(song,fs)
end

