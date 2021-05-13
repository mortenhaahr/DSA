function y = toRealnumber(x, multFactor)
    % Funktion for convertering fra double/float til heltal
    y = round(x*multFactor);
    if (y >= multFactor) 
        y = multFactor-1; % Limitering af max værdi
    end
end
