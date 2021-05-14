 function [R, lag] = myXCorr(receivedSignal, chirpSignal)
%myXCorr Cross correlation function used to find out signal runtime to
%object and back

N_chirp = length(chirpSignal);
N_received = length(receivedSignal);
N_xCorr = N_chirp+N_received-1;

receivedSignalPadded = [zeros(1, N_chirp-1), receivedSignal];
R_off = N_chirp;
R = zeros(1, N_xCorr+N_chirp);
lag = zeros(1, N_xCorr+N_chirp);

for i = -(N_chirp-1):N_xCorr
    lag(R_off+i)= i;
    for j = 1:N_chirp
        if(R_off+j+i) <= N_xCorr
            R(R_off+i) = R(R_off+i)+(chirpSignal(j)*receivedSignalPadded(R_off-1+j+i));
        end
    end 
end