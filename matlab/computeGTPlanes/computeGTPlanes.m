% test boxes3D_pt1
clc
close all
clear all

in_path='../../data/boxAndSceneFeatures/';
out_path='../../data/gtTopPlane/';
load([in_path 'boxes3D_p1.mat'])
scene=5;

%% load ID by scene
boxID=BoxIDperScene(:,scene);
%% load size by scene
[ind val]=find(BoxSize(:,1)==boxID');

Height=BoxSize(ind,2)/1000;
Width=BoxSize(ind,3)/1000;
Depth=BoxSize(ind,4)/1000;
%% load position by scene
PositionW=cell2mat(GtDetection_W(scene))/1000;
PositionC=cell2mat(GtDetection_C(scene));
AzimuthAngle=cell2mat(GtPose_W(scene));
%% display data
display(["Scene " num2str(scene)])
T=table(boxID, Height, Width, Depth, PositionW, PositionC, AzimuthAngle)
minDistance=computeMinHeightDistance(T);

%% computeplanes from data
pc=computePlanes(PositionW, boxID, AzimuthAngle, [Height Width Depth], scene);
%% save planes
return
% save in PLY
pcwrite(pc, [out_path 'scene_' num2str(scene) '_worldPlane.ply'],'PLYFormat', 'binary');
% save in PCD
pcwrite(pc,[out_path 'scene_' num2str(scene) '_worldPlane.pcd'],'Encoding','ascii');
