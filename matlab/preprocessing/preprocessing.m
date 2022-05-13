clc 
close all
clear all

% load depth map from point cloud
    scene=5;
    in_path='../../data/pcScene/';
    out_path='../../data/pcSceneFiltered/';
    load([in_path 'e' num2str(scene) '.mat'], 'ptCloud_set', 'experimentName');

%     merge samples to enhance density of points
    pc12=pcmerge(ptCloud_set{1},ptCloud_set{2},0.001);
    pc34=pcmerge(ptCloud_set{3},ptCloud_set{4},0.001);
    pc1_4=pcmerge(pc12,pc34,0.001);
    pcshow(pc1_4)
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    
%   extract a roi
    roi=scene2ROI(scene);
    indices = findPointsInROI(pc1_4,roi);
    pc1_4 = select(pc1_4,indices);
%     apply a denoise 
    pc1_4 = pcdenoise(pc1_4);
    figure,
    pcshow(pc1_4)
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    axis(roi)
    view(146-180+20, -87)
    title ('scene 5. Boxes referenced to camera ref system')
    
    saveas(gcf, 'filteredScenev2.png')
    
% save in PLY
pcwrite(pc1_4, [out_path 'scene_' num2str(scene) '_camera.ply'],'PLYFormat', 'binary');
% save in PCD
pcwrite(pc1_4,[out_path 'scene_' num2str(scene) '_camera.pcd'],'Encoding','ascii');

    
    
