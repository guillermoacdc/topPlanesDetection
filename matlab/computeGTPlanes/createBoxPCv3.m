function [m mc mca] = createBoxPCv3(L,W,H,flagTopBox)
%CREATEBOXPC Create a model of a box in R3 and locates its origin at the
%top of the box, geometric center

%   Detailed explanation goes here
% input.
% L: Length--width
% W: Width--depth
% H: Height--height
% step: distance between adjacent points

% output.
% m: box in Nx3 matrix. origin at lower corner
% mc: box in Nx3 matrix. origin at geometric center of top box
% mca: box in Nx4 matrix. The last column has value one (augmented vector).
% origin at geometric center of top box
if (flagTopBox)
    step=1/1000;
    [x,y,z] = ndgrid(1/1000:step:L, 1/1000:step:W, H);%generate top
else
    step=10/1000;
    [x,y,z] = ndgrid(1/1000:step:L, 1/1000:step:W, 1/1000:step:H);%generate all the box
end



m=[x(:),y(:),z(:)];

ma=ones(size(m,1),4);
ma(:,1:3)=m;

T1=[1 0 0 -L/2; 0 1 0 -W/2;0 0 1 -H; 0 0 0 1];

for i=1:length(ma)
    mca(i,:)=T1*ma(i,:)';
end
mc=mca(:,1:3);
% mc=m;

end

