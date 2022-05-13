clc
close all
clear all

scene=5;
% in_path='../../data/topPlane/scene';
in_path='../../data/pcSceneFiltered/scene_';
out_path='../../data/mapOfPlanes/';

% load the point cloud

pc=pcread([in_path num2str(scene) '_camera.ply'])
