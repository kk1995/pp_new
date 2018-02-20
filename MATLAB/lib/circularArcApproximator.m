function [slider_points, dist] = circularArcApproximator(a,b,c)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
aSq = sum((b - c).^2); bSq = sum((a - c).^2); cSq = sum((a - b).^2);
    s = aSq * (bSq + cSq - aSq); t = bSq * (aSq + cSq - bSq); u = cSq * (aSq + bSq - cSq);
    sum_dist = s + t + u;
    centre = (s * a + t * b + u * c) / sum_dist;
    dA = a - centre; dC = c - centre;
    r = sqrt(sum(dA.^2));
    thetaStart = atan2(dA(2), dA(1));
    thetaEnd = atan2(dC(2), dC(1));
    while thetaEnd < thetaStart
        thetaEnd = thetaEnd + 2*pi;
    end
    dir = 1;
    thetaRange = thetaEnd - thetaStart;
    orthoAtoC = c - a; % direction
    orthoAtoC = [orthoAtoC(2) -orthoAtoC(1)];
    if dot(orthoAtoC,(b-a)) < 0
        dir = -dir;
        thetaRange = 2*pi - thetaRange;
    end
    amountPoints = 2001;
    slider_points = nan(amountPoints,2);
    for i = 1:amountPoints
        fract = (i-1)/(amountPoints-1);
        theta = thetaStart + dir * fract * thetaRange;
        slider_points(i,:) = [cos(theta) sin(theta)]*r;
    end
    slider_points(:,1) = slider_points(:,1) + centre(1);
    slider_points(:,2) = slider_points(:,2) + centre(2);
    
    x_diff = diff(slider_points(:,1));
    y_diff = diff(slider_points(:,2));
    dist = sum(sqrt(x_diff.^2 + y_diff.^2));
end