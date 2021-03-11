function [string] = FSKDecoder(x, fstart, fstop, fsample, symbolDuration)
    N_full = length(x); %Determine number of samples
    DFTBlockSize = fsample*symbolDuration; %Calculate size of DFT-block according to symbolDuration
    numOfChars = floor(N_full/DFTBlockSize); %Calculate number of chars in signal
    
    string = zeros(1, numOfChars);
    k = 1;
    for i = 1:DFTBlockSize:numOfChars*DFTBlockSize % For loop iterating over number of chars with changing block start and stop samples
        
        % Defining block and applying window:
        x_block = x(i:i+DFTBlockSize-1);
        wGauss = gausswin(length(x_block)); 
        x_block = x_block.*wGauss; %Adding Gauss window function to reduce spectral leakage
        
        % Applying zero padding if needed:
        if(length(x_block) < fsample/2) % If length < fs/2, apply zero padding
            x_block = [x_block; zeros(fsample/2-length(x_block), 1)];
        end
        
        % Finding bin_res and necessary bins to calculate for:
        bin_res = fsample/length(x_block);
        freqArray = linspace(fstart, fstop, 256*bin_res); %Restore original frequency array to determine bins to calculate
        binIndices = round(freqArray/bin_res); %Indices of bins to calculate
        
        % Calculating frequency bins:
        X = zeros(1, length(binIndices));
        for j = 1:length(binIndices) % For loop iterating over all possible frequency bins
            X(j) = specifiedBinDFT(x_block, binIndices(j));
        end

        [~, highest_bin] = max(abs(X)); %Determining the bin index of highest peak which is the frequency of the char
 
        string(k) = highest_bin/bin_res; %Value of the char. 
        k = k+1;
    end
    string = char(string); % Convert indices to chars
end

