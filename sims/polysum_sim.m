n = 6;
x = -2:1e-4:2;
y = polysum(x,n);
r = abs(y-0.5)<1e-4; 
rid = find(r==1);
% r = min(abs(y)); 
% rid = find(y==r);
if isempty(rid)
    rid = find(y==-r);
end
xr = x(rid); yr = y(rid);
close all; 
hold on;
plot(x,y);hold on; grid on;
plot(xr,yr,'o'); hold off;

% poly variable
