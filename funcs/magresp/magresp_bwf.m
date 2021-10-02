function [magsq, mag] = magresp_bwf(freqw,wn,n)
% MAGRESP_BWF
% Computes Magnitude Response of the BWF
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
%
normfreqw = (freqw./wn);
%
fl_term = 1 + (normfreqw).^(2*n);
magsq = 1./fl_term;
mag = 1./sqrt(fl_term);

end