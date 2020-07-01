function tau_g = grpdel(freqw,wn,n)
magsq_udbf = magresp_udbf(freqw,wn,n);
fp_term =  magsq_udbf;

fl_term = n + (freqw./wn).^((2*n) - 2);

mid_term = 0;
rho = rhoval(n);

for id=(n-2):-1:1
    t = n-id-1; lambda_t = 0;
    if ( (id >= (n/2) ) && isintegereven(n) ) ...
            || ( (id >= ((n-1)/2) ) && ~isintegereven(n) )
        r_bar = n-id;
    else
        r_bar=id+1;
    end
    for r=1:1:r_bar
        j = t+1-r; k = t+r;
        lambda_t = lambda_t + ((-1)^(r-1))*(bpc_skern(n,j,0,rho))*(bpc_skern(n,k,0,rho));
    end
    mid_term = mid_term + lambda_t.*(freqw./wn).^(2*id);
end

sump_term = fl_term + mid_term;
tau_g = fp_term.*sump_term;

end