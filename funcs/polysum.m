function R = polysum(z,n)
% POLYSUM: Polynomial Summation
arguments
    z % polynomial variable
    n % polynomial order
end

% udbm
coeffs = udbmfpoly1d(n,0,1);
R = 1;
for id = 1:n
   R = R + ( coeffs(id+1).*(z).^(id) );
end
    
end