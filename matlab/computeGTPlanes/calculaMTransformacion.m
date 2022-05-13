function [T] = calculaMTransformacion(alpha,pb)
%CALCULAMTRANSFORMACION Summary of this function goes here
%   Detailed explanation goes here
% alpha. angle in degrees, in the range 0-180.
% pb. augmented vector of position referenced to base system

R=zeros(3);
R(end)=1;
alpha=alpha*pi/180;%transformation to radians
if (alpha>=0) && (alpha<=pi)
    R(1:2,1:2)=[cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];
elseif (alpha>pi/2) && (alpha<=pi)
    R(1:2,1:2)=[-cos(alpha) -cos(alpha-pi/2); sin(alpha) -sin(alpha-pi/2)];
else
    disp( 'angle out of range')
    return
end
T=zeros(4);
T(1:3,1:3)=R;
T(:,4)=pb;

end

