% test boxes3D_pt1
clc
close all
clear all

in_path='../../data/boxAndSceneFeatures/';
out_path='../../data/gtTopPlane/';
out_path2='../../data/pcSceneFiltered/';
load([in_path 'boxes3D_featuresPerScene.mat']);
scene=1;

%% load ID by scene
boxID=BoxIDperScene(:,scene);
%% load size by scene
[ind val]=find(BoxSize(:,1)==boxID');

Height=BoxSize(ind,2);
Width=BoxSize(ind,3);
Depth=BoxSize(ind,4);
%% load position by scene
PositionW=cell2mat(GtDetection_W(scene));
% PositionC=cell2mat(GtDetection_C(scene));
AzimuthAngle=cell2mat(GtPose_W(scene));
%% display data
display(["Scene " num2str(scene)])
T=table(boxID, Height, Width, Depth, PositionW, AzimuthAngle)
% minDistance=computeMinHeightDistance(T);
return
%% computeplanes from data
pc=computePlanes(PositionW, boxID, AzimuthAngle, [Height Width Depth], scene);
%% save planes
return
% save in PLY
pcwrite(pc, [out_path 'scene_' num2str(scene) '_worldFrame.ply'],'PLYFormat', 'binary');
% save in PCD
pcwrite(pc,[out_path 'scene_' num2str(scene) '_worldFrame.pcd'],'Encoding','ascii');
return


% load transformation matrix for pose 1. Valid for scenes 1, 6, 7, 29
R=load([in_path 'RMatrix_p1.txt']);
t=load([in_path 'Tvector_p1.txt']);

% apply transformation
m=[pc.Location(:,1),pc.Location(:,2),pc.Location(:,3)];
ma=ones(size(m,1),4);
ma(:,1:3)=m;

T1=[1 0 0 0; 0 1 0 0;0 0 1 0; 0 0 0 1];
T1(1:3,1:3)=R;
T1(1:3,4)=t;

for i=1:length(ma)
    mca(i,:)=T1*ma(i,:)';
end
mc=mca(:,1:3);
pc_t=pointCloud(mc);
% plot transformed scene
figure,
pcshow(pc_t,'MarkerSize',60)
xlabel 'x'
ylabel 'y'
zlabel 'z'
% save in PLY
pcwrite(pc_t, [out_path2 'scene_' num2str(scene) '_gtCameraFrameTop.ply'],'PLYFormat', 'binary');
% save in PCD
pcwrite(pc_t,[out_path2 'scene_' num2str(scene) '_gtCameraFrameTop.pcd'],'Encoding','ascii');

return
