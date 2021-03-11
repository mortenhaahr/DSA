function [string] = FSKDecoder(x, fstart, fstop, fsample, symbolDuration)
    
    N_full = length(x); %Determine number of samples
    DFTBlockSize = fsample*symbolDuration; %Calculate size of DFT-block according to symbolDuration
    bin_res = fsample/DFTBlockSize;
    numOfChars = floor(N_full/DFTBlockSize); %Calculate number of chars in signal
    freqArray = linspace(fstart, fstop, 256); %Restore original frequency array to determine bins to calculate
    binIndices = round(freqArray/bin_res); %Indices of bins to calculate
    wGauss = gausswin(length(x)); 
    x = x.*wGauss; %Adding Gauss window function to reduce spectral leakage
    
    string = zeros(1, numOfChars);
    k = 1;
    for i = 1:DFTBlockSize:numOfChars*DFTBlockSize % For loop iterating over number of chars with changing block start and stop samples
        x_block = x(i:i+DFTBlockSize-1);
        
        for j = 1:length(binIndices) % For loop iterating over all possible frequency bins
            X(j) = specifiedBinDFT(x_block, binIndices(j));
        end

        [~, highest_bin] = max(abs(X)); %Determining the bin index of highest peak which is the frequency of the char
 
        string(k) = highest_bin;
        k = k+1;
    end
    string = char(string); % Convert indices to chars
end

