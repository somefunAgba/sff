function [magsq_udbf, mag_udbf, magsq_but, mag_but, magsq_bin, mag_bin] = magresp_udbf(freqw,wn,n)

fl_term = 1 + (freqw./wn).^(2*n);
magsq_but = 1./fl_term;
mag_but = 1./sqrt(fl_term);

% uniformly-damped BINOMIAL

mid_term = 0;
o_term=0; % origin term;
rho = rhoval(n);

for id=(n-1):-1:1
    t = n-id; alpha_t = 0;
    if ( (id >= (n/2) ) && isintegereven(n) ) ...
            || ( (id >= ((n+1)/2) ) && ~isintegereven(n) )
        r_bar = n-id;
    else
        r_bar=id;
    end
    for r=1:1:r_bar
        j = t-r; k = t+r;
        alpha_t = alpha_t + ((-1)^(r))*(bpc_skern(n,j,0,rho))*(bpc_skern(n,k,0,rho));
    end
    alpha_t = (bpc_skern(n,t,0,rho))^2 + 2*alpha_t;
    mid_term = mid_term + alpha_t.*(freqw./wn).^(2*id);
    %     o_term = o_term + alpha_t;
    
end
% disp(o_term)
den = fl_term + mid_term;
magsq = 1./den;
magsq_udbf = magsq;
mag_udbf = 1./sqrt(den);

% STANDARD BINOMIAL
mid_term = 0;
rho = 1;
for id=(n-1):-1:1
    t = n-id; alpha_t = 0;
    if ( (id >= (n/2) ) && isintegereven(n) ) ...
            || ( (id >= ((n+1)/2) ) && ~isintegereven(n) )
        r_bar = n-id;
    else
        r_bar=id;
    end
    for r=1:1:r_bar
        j = t-r; k = t+r;
        alpha_t = alpha_t + ((-1)^(r))*(bpc_skern(n,j,0,rho))*(bpc_skern(n,k,0,rho));
    end
    alpha_t = (bpc_skern(n,t,0,rho))^2 + 2*alpha_t;
    mid_term = mid_term + alpha_t.*(freqw./wn).^(2*id);
    %     o_term = o_term + alpha_t;
end
% disp(o_term);
den = fl_term + mid_term;
magsq_bin = 1./den;
mag_bin = 1./sqrt(den);

end