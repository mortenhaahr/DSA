function [crossCorrelation] = myXCorr(chirpSignal, receivedSignal)
%myXCorr Cross correlation function used to find out signal runtime to
%object and back
diff = abs(receivedSignal-chirpSignal);
if(length(chirpSignal) > length(receivedSignal))
    minLim = -length(chirpSignal);
    maxLim = length(chirpSignal);
    receivedSignal = receivedSignal(
else
    minLim = -length(receivedSignal);
    maxLim = length(receivedSignal);
end
    
N_xCorr = ((length(chirpSignal)+length(receivedSignal)-1);

for
    
    
    
end

