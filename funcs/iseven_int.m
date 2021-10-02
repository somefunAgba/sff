function y = iseven_int(x)
% ISEVEN_INT
arguments
    x; % integer or number to test
end
% tests if an integer x is even or odd
% returns 1 for even x, 0 for odd x.

x = round(x); % for real numbers

% y = bitand(x,1); % (x & 1)
% y = ~y; % ~(x & 1)
y = ~bitand(x,1); % ~(x & 1)

end