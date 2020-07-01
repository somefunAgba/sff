function [phase, tau_p, inum, rden] = phasedel(freqw,wn,n)

tau_p = wn./freqw;
rho = rhoval(n);
inum = 0; rden = 0;

for id = 0:1:n
    
    if (~isintegereven(id))
        x = (id-1)/2;
        w = ((-1).^(x)).*(freqw./wn).^(id);
        c = (bpc_skern(n,id,0,rho));
        inum = inum + (w.*c);
    end
    if (isintegereven(id))
        x = (id)/2;
        w = ((-1).^(x)).*(freqw./wn).^id;
        c = (bpc_skern(n,id,0,rho));
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