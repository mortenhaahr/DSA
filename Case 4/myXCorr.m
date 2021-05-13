 function [R, lag] = myXCorr(receivedSignal, chirpSignal)
%myXCorr Cross correlation function used to find out signal runtime to
%object and back

N_chirp = length(chirpSignal);
N_received = length(receivedSignal);
N_xCorr = N_chirp+N_received;

receivedSignalPadded = [zeros(1, N_chirp), receivedSignal];
R_offset = N_chirp;
R = zeros(1, N_xCorr+N_chirp);
lag = zeros(1, N_xCorr+N_chirp);
for i = -N_chirp:N_xCorr-1
    lag(i+N_chirp+1)= i;
    for j = 1:N_chirp
        if(N_chirp+j+i) <= N_xCorr
            R(R_offset+1+i) = R(R_offset+1+i)+(chirpSignal(j)*receivedSignalPadded(R_offset+j+i));
        end
    end 
end