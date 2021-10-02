function [magsq, mag] = magresp_bmf(freqw,wn,n)
% MAGRESP_BMF
% Computes Magnitude Response of the BMF
%
% OUTPUTS:
% - magsq: squared magnitude response
% - mag : magnitude response
arguments
    freqw % frequnecies
    wn % natural frequency wn 
    n % s-polynomial degree
end
% freqw./wn -> normalized freuencies
% if freqw is already normalized, set wn = 1

normfreqw = (freqw./wn);
% STANDARD BINOMIAL
damper = 1;
fl_term = 1 + (normfreqw).^(2*n);
mid_term = 0;
%
for id=(n-1):-1:1
    t = n-id; alpha_t = 0;
    if ( (id >= (n/2) ) && iseven_int(n) ) ...
            || ( (id >= ((n+1)/2) ) && ~iseven_int(n) )
        r_bar = n-id;
    else
        r_bar=id;
    end
    for r=1:1:r_bar
        j = t-r; k = t+r;
        alpha_t = alpha_t + ...
            ((-1)^(r))*(dbpcoef(n,j,0,damper))*(dbpcoef(n,k,0,damper));
    end
    alpha_t = (dbpcoef(n,t,0,damper))^2 + 2*alpha_t;
    mid_term = mid_term + alpha_t.*(normfreqw).^(2*id);

end
%
den = fl_term + mid_term;
magsq = 1./den;
mag = 1./sqrt(den);

end