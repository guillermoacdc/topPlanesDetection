clc
close all
clear all
% packing data of BoxesRGBD

%% PointCloudScenes
% Cell of Nscenes elements; Nscenes corresponds with the number of scenes. 
% Each element is a cell of four elements with each one of the samples 
% taked in a single scene. Each sample has been taken from a common point 
% of view of the scene and has the attributes: Location, Color, Count, 
% Xlimits,  Ylimits and Zlimits as defined in ptCloud objects of matlab
Nscenes=12;
pointCloudScenes={};
SceneName={}; %Cell of Nscenes size with the name of each scene

for i=1:Nscenes
    eval(['load(''e' num2str(i) '.mat'', ''ptCloud_set'', ''experimentName'');'])
    PointCloudScenes{i}=ptCloud_set;
    SceneName{i}=experimentName;
end

%% BoxIDperScene, GtDetection_W, GtPose_W
% BoxIDperScene. Vector of Nboxes_scene x Nscenes size.  Each element 
% corresponds with the % set of Ids of boxes at the scene
Nboxes_scene=4;%number of boxes per scene
BoxIDperScene=zeros(Nboxes_scene,Nscenes);

% GtDetection_W. Ground Truth of detection problem in world frame.  Cell of
% Nscenes elements. Each element has the p_grasping coordinate for each of 
% the Nboxes at the scene. The p_grasping coordinate is a 3D coordinate 
% which corresponds with the geometric center of the top surface of the box.  
% The world frame is common frame for all the scenes.
GtDetection_W={};

% GtPose_W.Ground Truth for the pose detection problem in world frame.  
% Cell of Nscenes elements. Each element has the azimuth angle for each of 
% the Nboxes at the scene. The angle is measured with respect to the world 
% frame; this frame is coplanar with the groundth. Angle in degrees
GtPose_W={};

path2='C:\Users\guill\Documents\Investigacion GAC\UnisalleRGBDBoxes\datos\GroundTruth\TXT';
formatSpec = '%f';


for i=1:Nscenes
    % ----------------------
    fileID = fopen([path2 '\e' num2str(i) '.txt'],'r');
    A = fscanf(fileID,formatSpec);
    A=reshape(A,5,4)';
    % ------------
    ids=A(:,4);
    position_gt=A(:,1:3);
    azimuthAngle_gt=A(:,5);

    BoxIDperScene(:,i)=ids;
    GtDetection_W{i}=position_gt;
    GtPose_W{i}=azimuthAngle_gt;
end
fclose(fileID);

%% LabelImages, Labels
% LabelImages. Matrix of WxHxNscenes. Mask with categorical labels of classes 
% and box instances in the scene
path3='G:\Mi unidad\semestre 4\database\meet1509\RGB1\Guillermo';
load([path3 '\labelDefinitions_25092020.mat'])
LabelDescriptor=labelDefs;

W=1080;
H=1920;
LabelImages=uint8(zeros(W,H,Nscenes));
imageIndex=[1 5:12 2:4];%it depends on the labeler application
% imread('Label_1.png')
% labelIm=imread([path3 '\PixelLabelData_1\Label_1.png']);

for i=1:Nscenes
    eval([ 'labelIm=imread([path3 ''\PixelLabelData_1\Label_' num2str(imageIndex(i)) '.png'']);' ]);
    LabelImages(:,:,i)=labelIm;
end

%% GtDetection_C
% Ground Truth of detection problem in camera frame. Cell of Nscenes 
% elements. Each element has the p0 coordinate for each of the Nboxes at 
% the scene. The p0 coordinate is a 3D coordinate wich corresponds with the 
% point of intersection of three points in the visible cuboid. 

GtDetection_C={}; 

path4='C:\Users\guill\Documents\Investigacion GAC\UnisalleRGBDBoxes\datos\avance1\code';


for i=1:Nscenes
    % ----------------------
    filename=[path4 '\e' num2str(i) '_detection.txt'];
    T = readtable(filename);
    A = table2array(T);
    position_gt=A(:,2:4);
    GtDetection_C{i}=position_gt;
end

%% box size
% BoxSize: Matrix of 3xNboxes_total. Each column has information of ID, Height, 
% width and depth of a single box. The boxes are placed with a single side-up

path5='C:\Users\guill\Documents\Investigacion GAC\UnisalleRGBDBoxes\datos\GroundTruth';
filename=[path5 '\BoxesFeatures.xlsx'];
T = readtable(filename);
A = table2array(T);
BoxSize=A(:,[2 7 3 5]);



%% example figures
scene=3;
sample=1;
% sample color image
sampleImage=PointCloudScenes{1,scene}{1,sample}.Color;
figure,
imshow(sampleImage)
title (['Color Image. Scene:' num2str(scene) '. Sample:' num2str(sample)])
% sample point cloud
    ptCloudSample=PointCloudScenes{1,scene}{1,sample};
%     R = roty(180);
%     A=zeros(4,4);
%     A(1:3,1:3)=R;
%     A(end)=1;
%     tform = affine3d(A);
%     ptCloudSample = pctransform(ptCloudSample,tform);
%     

figure,
pcshow(ptCloudSample)
title (['Point Cloud. Scene:' num2str(scene) '. Sample:' num2str(sample)])
xlabel 'x'; ylabel 'y'; zlabel 'z';
axis([-1 1 -1 1 0 2])
view(-10,-70)
% axis([-1 1 -2 1 -3 0])

% sample label image
sampleLabel= LabelImages(:,:,scene);
figure,
imagesc(sampleLabel);
% colorbar
labelIDs=unique(sampleLabel);
labelTicks={LabelDescriptor.Name{labelIDs}};
colorbar('Ticks',labelIDs,...
         'TickLabels',labelTicks)
title (['Labeled Image. Scene:' num2str(scene) '. Sample:' num2str(sample)])

% table with ID, size, GT (position, azimuth angle)

%% saving data
save('boxes3D_p1.mat', 'PointCloudScenes', 'BoxIDperScene',...
    'LabelDescriptor', 'LabelImages', 'GtDetection_C', 'GtDetection_W',...
    'GtPose_W', 'BoxSize', 'SceneName');