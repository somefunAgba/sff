function [phase, tau_p, inum, rden] = phasedel(freqw,wn,n)
% PHASEDEL
% Computes Phase Delay of the DBF
arguments
    freqw % frequnecies
    wn % natural frequency wn 
    n % s-polynomial degree
end

% freqw./wn -> normalized freuencies
% if freqw is already normalized, set wn = 1

normfreqw = (freqw./wn);
tau_p = 1./normfreqw;
%
damper = const_udbmf5(n);
inum = 0; rden = 0;
%
for id = 0:1:n
    c = dbpcoef(n,id,0,damper);
    if (~iseven_int(id))
        x = (id-1)/2;
        w = ((-1).^x).*(normfreqw).^id;       
        inum = inum + (w.*c);
    end
    if (iseven_int(id))
        x = (id)/2;
        w = ((-1).^x).*(normfreqw).^id;
        rden = rden + (w.*c);
    end
    
end

% x = inum./rden;
phase = -(atan2(inum,rden));

% correct the radian phase angles in a phase angle vector by adding 
% multiples of ±2pi when absolute jumps between consecutive elements of the vector
% are greater than or equal to the default jump tolerance of pi radians.
phase = unwrap(phase);

% convert to deg.
% phase = phase*180/pi;

tau_p = -tau_p .* phase;

end