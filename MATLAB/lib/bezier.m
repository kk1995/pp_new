function [slider_points, dist] = bezier(points)
%BEZIER Building bezier curve from n points in nx2 form
%   Detailed explanation goes here

amountPoints = 1001;
n = size(points,1);
n1=n-1;
sigma = nan(n1+1,1);
for i=0:1:n1
    sigma(i+1)=factorial(n1)/(factorial(i)*factorial(n1-i));  % for calculating (x!/(y!(x-y)!)) values
end
l=[];
UB=[];
for u=linspace(0,1,amountPoints)
    for d=1:n
        UB(d)=sigma(d)*((1-u)^(n-d))*(u^(d-1));
    end
    l=cat(1,l,UB);                                      %catenation
end
slider_points = l*points;

x_diff = diff(slider_points(:,1));
y_diff = diff(slider_points(:,2));
dist = sum(sqrt(x_diff.^2 + y_diff.^2));
end

