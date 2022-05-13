function [maxArea minH] = computeMaxAreaSurface(scene)
%COMPUTEMAXAREASURFACE Summary of this function goes here
%   Detailed explanation goes here


in_path='../../data/boxAndSceneFeatures/';
load([in_path 'boxes3D_p1.mat'],'BoxIDperScene', 'BoxSize')


%% load ID by scene
boxID=BoxIDperScene(:,scene);
%% load size by scene
[ind val]=find(BoxSize(:,1)==boxID');

Height=BoxSize(ind,2)/1000;
Width=BoxSize(ind,3)/1000;
Depth=BoxSize(ind,4)/1000;
%% load position by scene
% PositionW=cell2mat(GtDetection_W(scene))/1000;
% PositionC=cell2mat(GtDetection_C(scene));
% AzimuthAngle=cell2mat(GtPose_W(scene));
%% compute maximal surface
% display(["Scene " num2str(scene)])
% T=table(boxID, Height, Width, Depth, PositionW, PositionC, AzimuthAngle)
for i=1:4
    s1=Height(i)*Width(i);
    s2=Depth(i)*Width(i);
    s3=Depth(i)*Height(i);
    maxSurface_b(i)=max([s1 s2 s3]);
end
maxArea =max(maxSurface_b);
minH=min(Height);
end

