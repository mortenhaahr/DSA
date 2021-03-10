  function [symbol, symbolValue, freq] = FSKDecoder(x, fstart, fstop, fsample, zerop)

    x = [x; zeros(round(zerop), 1)];

    step = (fstop-fstart)/256;
    bin_res = fsample/length(x);
    bin_n_min = floor(fstart/bin_res);
    bin_n_max = floor(fstop/bin_res);
    
    wGauss = gausswin(length(x));
    x = x.*wGauss;
    
    X = specifiedBinDFT(x, bin_n_min, bin_n_max);
    [bin_mag, highest_bin] = max(abs(X));
    highest_bin = highest_bin + bin_n_min;   
    
    bin_freq = highest_bin*bin_res;
    symbolValue = (bin_freq-fstart)/step;
    symbol = char(round(symbolValue));
    freq = bin_freq;
end