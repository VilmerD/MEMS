% Compute the principle strains and their direction
function [e1, e2, th] = Principle(exx, eyy, exy)
% Assumes that the plane is orthogonal to a principle direction
% (plane stress or plane strain)
m = (exx + eyy) / 2;
d = (exx - eyy) / 2;
R = sqrt(d.^2 + exy.^2);

e1 = m + R;
e2 = m - R;

twoang0 = atan(exy ./ d);

% Compute offset based on which quadrant the thing is in
c = d ./ R;
s = exy ./ R;

% If c and s are positive, then the point is in the first quadrant,
% then also tangent will give the correct angle
mask1 = (c > 0) .* (s > 0);
off = zeros(size(mask1));

% if c is negative and s is positive, then the point is in the second quadrant
% The correct 2*angle will be between pi and pi/2. But tan will give between -pi/2 and 0
% so we must take pi + 2*ang to get the correct angle
mask2 = (c <= 0) .* (s > 0);
off = off + (pi * mask2);

% if c is negative and s is negative, then the point is in the third quadrant,
% The correct 2*angle will be between 3pi/2 and pi, but atan will give an angle between pi/2 and 0, 
% so we must take pi + 2*ang to get the correct angle
mask3 = (c <= 0) .* (s <= 0);
off = off + (pi * mask3);

% if c is positive and s is negative, then the point is in the fourth quadrant
% The correct 2*angle will be between 3pi/2 and 2pi. But tan will give between -pi/2 and 0
% so we must take 2*pi + 2*ang to get the correct angle 
mask4 = (c > 0) .* (s <= 0);
off = off + (2*pi * mask4);

th = (twoang0 + off) / 2;

end