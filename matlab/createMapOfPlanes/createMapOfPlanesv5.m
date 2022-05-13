clc
close all
clear all


in_path='../../data/topPlane/scene';
in_path2='../../data/pcSceneFiltered';
out_path='../../data/mapOfPlanes/';


scene=5;
[maxA minH]=computeMaxAreaSurface(scene);

pcRef=pcread([in_path2 '/scene_' num2str(scene) '_camera.ply']);

k=1;
maxI=50;
for i=0:maxI
    fileName{i+1}=[in_path num2str(scene) '/inliers_planeModel_' num2str(i) '.ply'];
    ptCloud{i+1} = pcread(fileName{i+1});
    ptCloud{i+1} = pcdenoise(ptCloud{i+1});
%     remove outliers based on distance: median absolute deviation (MAD)
  
    xp=double(ptCloud{i+1}.Location(:,1));
    yp=double(ptCloud{i+1}.Location(:,2));
    zp=double(ptCloud{i+1}.Location(:,3));
    if i==0%ground plane
        eval('coeffs=load([in_path num2str(scene) ''/coeff'' num2str(i) ''.txt'']);');
        Ag=coeffs(1);
        Bg=coeffs(2);
        Cg=coeffs(3);
        Dg=coeffs(4);
    end
    
    %     Remove planes with area major than a threshold (=1.5mt)
    myArea=(max(xp)-min(xp))*(max(yp)-min(yp));
    if(myArea<1.5)

%         load plane parameteres
        eval('coeffs=load([in_path num2str(scene) ''/coeff'' num2str(i) ''.txt'']);');
        A=coeffs(1);
        B=coeffs(2);
        C=coeffs(3);
        D=coeffs(4);
%     Criteria – Filter duplicates of ground. 
    if(abs(Dg)-abs(D)>minH/2)%definir el treshold igual a la altura mínima de caja en escena
        angle_n=computeAngleBtwnVectors([Ag Bg Cg],[A B C]);
        normalData(k,:)=[i Dg D  angle_n abs(Dg)-abs(D)];
        k=k+1;
        
        if (angle_n>0 & angle_n<10) | (angle_n>80 & angle_n<90) 
            
        normals = pcnormals(ptCloud{i+1});
        xn = xp(1:end);
        yn = yp(1:end);
        zn = zp(1:end);
        un = normals(1:end,1);
        vn = normals(1:end,2);
        wn = normals(1:end,3);
        
        
        [x y z] = createPlaneFromModel(xp, yp, zp, A, B, C, D);
        myArea2=(x(1,2)-x(1,1))*(y(2,1)-y(1,1));
        figure,
            pcshow(pcRef)
            hold on
            pcshow(ptCloud{i+1},'MarkerSize', 40)
            hold on
            surf(x,y,z) %Plot the surface
            quiver3(xn,yn,zn,un,vn,wn);
            hold off
            xlabel 'x'
            ylabel 'y'
            zlabel 'z'
            axis([-1 0.5 -0.5 0.5 1 2.5])
            view(-10,-70)
            title (['Model:' num2str(i) '. Area1: ' num2str(myArea) '. Area2: ' num2str(myArea2) '. Number of Inliers: ' num2str(ptCloud{i+1}.Count)])
            pause(1)
        end
    end
    end
end
