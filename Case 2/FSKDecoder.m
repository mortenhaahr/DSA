function [string] = FSKDecoder(x, fstart, fstop, fsample, symbolDuration)
    
    N_full = length(x);
    DFTBlockSize = fsample*symbolDuration;
    bin_res = fsample/DFTBlockSize;
    numOfChars = floor(N_full/DFTBlockSize);
    freqArray = linspace(fstart, fstop, 256);
    binIndices = round(freqArray/bin_res);
    %binIndexes = freqArray/bin_res;
    wGauss = gausswin(length(x));
    x = x.*wGauss;
    
    string = zeros(1, numOfChars);
    k = 1;
    for i = 1:DFTBlockSize:numOfChars*DFTBlockSize
        x_block = x(i:i+DFTBlockSize-1);
        
        for j = 1:length(binIndices)
            X(j) = specifiedBinDFT(x_block, binIndices(j));
        end

        [~, highest_bin] = max(abs(X));
        freq = (highest_bin*bin_res)+fstart;
        %[~, sym] = min(abs(freqArray - freq));
        
        string(k) = highest_bin;
        %string(k) = sym;
        k = k+1;
    end
    string = char(string);
end

