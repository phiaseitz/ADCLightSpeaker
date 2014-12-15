function transfer = findtransferfunc(received, sent)
    %Takes in the initial signal (which should be a random header)
    %and and the received signal, which should not necessarily be processed
    % and outputs the estimated transfer function of the channel. We'll
    % have to zoom in to see the actual non-noisy things.
    
    Ryx = xcorr(received,sent)/(sent'*sent);
    %If we want to plot, we can uncomment this!
    plot(Ryx)
    
    transfer = Ryx;
end