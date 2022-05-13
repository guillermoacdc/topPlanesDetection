clc
close all
clear all

%% load data
scene=29;
in_path='../../data/pcSceneFiltered/scene_';
out_path=['../../data/topPlane/scene' num2str(scene)];
nameMat=([out_path '/parallelPlanes_t2']);
% load the point cloud
pc_raw=pcread([in_path num2str(scene) '_camera.ply']);
pc=pc_raw;
initSize=pc_raw.Count;
th_inliers=0.005;%
th_area=1;
i=1;

% compute ground model
model = pcfitplane(pc,th_inliers);%
model_g=model.Parameters;

%% extract planes parallel to ground
while (pc.Count>0.025*initSize)
% extract model
    [model inliers outliers]= pcfitplane(pc,th_inliers,model_g(1:3));%
    modelSet(i,:)=model.Parameters;
    if(i==1)
        inliersPCraw{i}=inliers;
    else
        pc_inliers=extractPoints(pc, inliers);
        inliersPCraw{i}=computeIndex(pc_raw, pc_inliers);
    end
    display(['Model ' num2str(i) ': ' num2str(length(inliers)) ' inliers. ' num2str(modelSet(i,:))])
 
% extract outliers
    pc_outliers=extractPoints(pc, outliers);
    pc=pc_outliers;
    i=i+1;
end


% mkdir out_path;
eval(['save(nameMat, ''inliersPCraw'', ''modelSet'')'])

return
normals=pcnormals(pc_raw);
testID=84;
pc_test=extractPoints(pc_raw, inliersPCraw{testID});
% cálculo puntos sobre el modelo de plano x, y,z 
xp=pc_test.Location(:,1);
yp=pc_test.Location(:,2);
zp=pc_test.Location(:,3);
[x y z] = createPlaneFromModel(xp, yp, zp, modelSet(testID,1), modelSet(testID,2),...
                                modelSet(testID,3), modelSet(testID,4));
% grafica de las normales modelo 25
        
        xn = double(pc_raw.Location(inliersPCraw{testID},1));
        yn = double(pc_raw.Location(inliersPCraw{testID},2));
        zn = double(pc_raw.Location(inliersPCraw{testID},3));
        un = normals(inliersPCraw{testID},1);
        vn = normals(inliersPCraw{testID},2);
        wn = normals(inliersPCraw{testID},3);
figure,
            pcshow(pc_raw)
            hold on
            pcshow(pc_test,'MarkerSize', 60)
            hold on
            surf(x,y,z) %Plot the surface
            quiver3(xn,yn,zn,un,vn,wn);
            title (['Plane Model ' num2str(testID) ])
            axis([-1 0.5 -0.5 0.5 1 2.5])
            view(-10,-70)
            

