function tau_g = grpdel(freqw,wn,n)
% GRPDEL
% Computes Group Delay of the DBF
arguments
    freqw % frequnecies
    wn % natural frequency wn 
    n % s-polynomial degree
end

% freqw./wn -> normalized freuencies
% if freqw is already normalized, set wn = 1

magsq_udbf = magresp_udbmf(freqw,wn,n);
fp_term =  magsq_udbf;
tau_g =  fp_term;
%
damper = const_udbmf5(n);
normfreqw = (freqw./wn);
fl_term = n + (normfreqw).^((2*n) - 2);
mid_term = 0;
%
for id=(n-2):-1:1
    t = n-id-1; lambda_t = 0;
    if ( (id >= (n/2) ) && iseven_int(n) ) ...
            || ( (id >= ((n-1)/2) ) && ~iseven_int(n) )
        r_bar = n-id;
    else
        r_bar=id+1;
    end
    for r=1:1:r_bar
        j = t+1-r; k = t+r;
        lambda_t = lambda_t + ((-1)^(r-1))*(dbpcoef(n,j,0,damper))*(dbpcoef(n,k,0,damper));
    end
    mid_term = mid_term + lambda_t.*(normfreqw).^(2*id);
end
%
sump_term = fl_term + mid_term;
tau_g = tau_g.*sump_term;

end