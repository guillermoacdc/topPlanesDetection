function [x y z] = createPlaneFromModel(xp, yp, zp, A, B, C, D)
%CREATEPLANEFROMMODEL Summary of this function goes here
%   Detailed explanation goes here

        x=[min(xp) max(xp) ; min(xp) max(xp)];
        y=[min(yp) min(yp); max(yp) max(yp) ];
        z = -1/C*(A*x + B*y + D); % Solve for z data
        

end

