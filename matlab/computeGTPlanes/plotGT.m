function [pc1_4_c]=plotGT(Position, IDbox, angle, boxSize, scene)

%% Definición de matrices de transformación de cada caja

for j=1:4
    T(:,:,j)=calculaMTransformacion(angle(j), [Position(j,:) 1]');
end

%% generaciónd de modelo de caja

for j=1:4
%     cargar dimensiones de caja
    [m mc mca] = createBoxPCv3(boxSize(j,3), boxSize(j,2), boxSize(j,1), 1);
    ptCloudBoxModel{j}=pointCloud(mc);
    mca_cell{j}=mca;
end

i=2;
pcshow(ptCloudBoxModel{i})
xlabel 'x'
ylabel 'y'
zlabel 'z'
axis tight
title (['box ' num2str(IDbox(i))])
hold on

% agregar ejes del sistema de referencia 
% draw_ref_system_3D(0,[0 0 0],IDbox(i));
% title (['box referenced to O_' num2str(IDbox(i))])
% hold off

T2=getTransfMatrix(scene);%transformation to camera frame for scene 1
%% transformación
for k=1:4
    for j=1:length(mca_cell{k})
          mta(j,:,k)=T(:,:,k)*mca_cell{k}(j,:)';%world coordinate system
          mta_c(j,:,k)=T2*mta(j,:,k)';%camera coordinate system
    end
end

% eliminación de columna aumentada
for k=1:4
    mt=mta(:,1:3,k);
    mt_c=mta_c(:,1:3,k);
    ptCloudT{k}=pointCloud(single(mt));
    ptCloudT_c{k}=pointCloud(single(mt_c));
end
%% presentación escena con cuatro cajas
pc1_4=myMergeClouds(ptCloudT);
pc1_4_c=myMergeClouds(ptCloudT_c);


figure,
    pcshow(pc1_4)
    hold on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['scene ' num2str(scene) '. Boxes referenced to world ref system'])
    view(0,45)
    draw_ref_system_3D(0,[0 0 0],0);
for k=1:4
     draw_ref_system_3D(angle(k)*pi/180,Position(k,:),IDbox(k));
end



% save in PLY
pcwrite(pc1_4, ['gtScene_' num2str(scene)],'PLYFormat', 'binary');
% save in PCD
pcwrite(pc1_4,['gtScene_' num2str(scene) '.pcd'],'Encoding','ascii');

% camera frame

figure,
    pcshow(pc1_4_c)
    hold on
    xlabel 'x'
    ylabel 'y'
    zlabel 'z'
    title (['scene ' num2str(scene) '. Boxes referenced to camera ref system'])
return




