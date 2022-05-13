function [pcout] = extractPoints(pcin,inliers)
%EXTRACTPOINTS Summary of this function goes here
%   Detailed explanation goes here

x=pcin.Location(:,1);
y=pcin.Location(:,2);
z=pcin.Location(:,3);
    xyz=[x(inliers) y(inliers) z(inliers)];
%     pc1=pointCloud(xyz);
pcout=pointCloud(xyz);
end

