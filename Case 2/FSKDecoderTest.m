function [string] = FSKDecoder(x, fstart, fstop, fsample, symbolDuration)
    
    N_full = length(x);
%     bin_res = fsample/length(x);
%     bin_n_min = floor(fstart/bin_res);
%     bin_n_max = floor(fstop/bin_res);
    DFTBlockSize = fsample*symbolDuration;
    numOfChars = floor(N_full/DFTBlockSize);
    freqArray = linspace(fstart, fstop, 256);
    
    wGauss = gausswin(length(x));
    x = x.*wGauss;
    
    string = zeros(1, numOfChars);
    j = 1;
    
    for i = 1:DFTBlockSize:numOfChars*DFTBlockSize
        x_block = x(i:i+DFTBlockSize-1);
        N_block = length(x_block);
        bin_res = fsample/N_block;
        bin_n_min = floor(fstart/bin_res);
        bin_n_max = floor(fstop/bin_res);
        X = specifiedBinDFT(x_block, bin_n_min, bin_n_max);
        [~, highest_bin] = max(abs(X));
        bin_freq = ((highest_bin-1)*bin_res)+fstart;
        [~, sym] = min(abs(freqArray-bin_freq));
        string(j) = sym;
        j = j+1;
    end
    string = char(string);
end

