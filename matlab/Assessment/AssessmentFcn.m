function [DP, MP, MD, SP, totalPlanes] = AssessmentFcn(scene, t, th_similitude)


% scene=6;
% th_similitude=0.2;%th of similitude between planes

% load gtPointCloud projected to camera view
in_path='../../data/pcSceneFiltered/';
fileName=[in_path '/scene_' num2str(scene) '_gtCameraFrameTop.ply'];
gtPointCloud = pcread(fileName);

% t=1;
% load map of planes
in_path=['../../data/mapOfPlanes/scene' num2str(scene) '/t' num2str(t)];
lis=dir([in_path '/parallel*']);
totalPlanes=length(lis);
% decompose gt in Nboxes cluster
% ------------meanshift
bandwidth=scene2bandwidth(scene);% size of the kernel to compute the mean
dataCluster=[gtPointCloud.Location(:,1) gtPointCloud.Location(:,2) gtPointCloud.Location(:,3)]';
[clustCentR,point2clusterR,clustMembsCellR] = MeanShiftCluster(dataCluster,bandwidth);
% the meanshift is not the best technique to resolve the clustering. A
% better technique could use information of the neighborhood of the points
% to detect discontinituies and select a cluster
% consultar
% Javan Hemmat, H., Pourtaherian, A., Bondarev, E., & de With, P. H. N. (2015). Fast planar segmentation of depth images. Image Processing: Algorithms and Systems XIII, 9399(c), 93990I. https://doi.org/10.1117/12.2083340
k=max(point2clusterR);
maxDistance=0.001;


% compute IoU matrix
conf_b=zeros(4,length(lis));
i=0;
for i=1:k
%     plot i-cluster gt
    pc_i=extractPoints(gtPointCloud,clustMembsCellR{i});
    model0 = pcfitplane(pc_i,maxDistance);
    n_gt=mypcFitPlane(pc_i,i);
    n_gt=[n_gt model0.Parameters(4)];
%     pause

%     
    for j=1:totalPlanes
        load([in_path '/' lis(j).name])%pcj A B C D
            [d1 d2 d3]=measureDissimilarityv2(pc_j,pc_i,[A,B,C,D],n_gt);
            conf(i,j)=d1+d2+d3;
            if(conf(i,j)<th_similitude)
                conf_b(i,j)=1;
                figure,
                pcshow(pc_i,'MarkerSize',40)%ground truth
                hold on
                plot3(pc_i.Location(1,1),pc_i.Location(1,2) ,pc_i.Location(1,3) ,'d')
                quiver3(pc_i.Location(1,1),pc_i.Location(1,2) ,pc_i.Location(1,3),n_gt(1),n_gt(2),n_gt(3),0.05);
                hold on

                myColor=uint8([1 1 1].*ones(length(pc_j.Location(:,1)),3));
                pc_j.Color=myColor;

                pcshow(pc_j,'MarkerSize',60)%detection
                title (['Plane in Scene ' num2str(scene) ': e_{diss}= ' num2str(conf(i,j)),...
                    ', d_{area}=' num2str(d1) ', d_{or}=' num2str(d2) ', d_{dist}=' num2str(d3) ])
                xlabel 'x'
                ylabel 'y'
                zlabel 'z'
%                 saveas(gcf,'e_diss.png')
                
            end
%             [d1 d2 d3]=measureDissimilarityv2(pc_j,pc_i,[A,B,C,D],n_gt);
            
    end
end

%% computing indexes
% (1) DP. Existing planes detected

for i=1:4
    DP_t=conf_b(i,:);

    DP_i(i)=0;
    for j=1:length(DP_t)
        if(DP_t(j)==1)
            DP_i(i)=1;
            break
        end
    end
end
DP=sum(DP_i);

% (2) MP. Number of existing planes that were detected multiple times
for i=1:4
    MP_i(i)=sum(conf_b(i,:));
end
multiple=MP_i-1;%identifica repeticiones
% pone en 0 valores negativos
for i=1:4
    if(multiple(i)<0)
        multiple(i)=0;
    end
end
% suma repeticiones
MP=sum(multiple);

% (3) MD. Number of missing planes

MD_ind=find(MP_i==0);
MD=length(MD_ind);

% (4) SP. Number of spurious planes
for j=1:size(conf_b,2)
    SP_j(j)=sum(conf_b(:,j));
end
SP_ind=find(SP_j==0);
SP=length(SP_ind);

% T=table(DP, MP, MD, SP, totalPlanes)
return
