function a=computeAngleBtwnVectors(P1,P2)

% P1=[8 0 0];
% P2=[4 4 0];

a = atan2(norm(cross(P1,P2)),dot(P1,P2)); % Angle in radians
a=a*180/pi;%angle in degrees