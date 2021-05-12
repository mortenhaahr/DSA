 function [R, lag] = myXCorr(chirpSignal, receivedSignal)
%myXCorr Cross correlation function used to find out signal runtime to
%object and back

N_received = length(receivedSignal);
N_chirp = length(chirpSignal);
N_xCorr = N_received+N_chirp;

chirpSigPadded = [zeros(1, N_received), chirpSignal];
R_offset = N_received;
R = zeros(1, N_xCorr+N_received);
lag = zeros(1, N_xCorr+N_received);
for i = -N_received:N_xCorr-1
    lag(i+N_received+1)= i;
    for j = 1:N_received
        if(N_received+j+i) <= N_xCorr
            R(R_offset+1+i) = R(R_offset+1+i)+(receivedSignal(j)*chirpSigPadded(R_offset+j+i));
        end
    end 
end