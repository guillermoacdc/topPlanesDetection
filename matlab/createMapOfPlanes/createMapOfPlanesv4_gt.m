clc
close all
clear all


in_path='../../data/topPlane/scene';
in_path2='../../data/gtTopPlane';
out_path='../../data/mapOfPlanes/';


scene=5;
maxA=computeMaxAreaSurface(scene);

pcRef=pcread([in_path2 '/scene_' num2str(scene) '_worldPlane.ply']);


maxI=3;
for i=0:maxI
    fileName{i+1}=[in_path num2str(scene) 'gt/inliers_planeModel_' num2str(i) '.ply'];
    ptCloud{i+1} = pcread(fileName{i+1});
%     ptCloud{i+1} = pcdenoise(ptCloud{i+1});
%     remove outliers based on distance: median absolute deviation (MAD)
  
    xp=double(ptCloud{i+1}.Location(:,1));
    yp=double(ptCloud{i+1}.Location(:,2));
    zp=double(ptCloud{i+1}.Location(:,3));

            %         load plane parameteres
        eval('coeffs=load([in_path  num2str(scene) ''gt/coeff'' num2str(i) ''.txt'']);');
        A=coeffs(1);
        B=coeffs(2);
        C=coeffs(3);
        D=coeffs(4);
        
    %     Filtering ground planes. All faces in the boxes have area less than 1mt2
    myArea=(max(xp)-min(xp))*(max(yp)-min(yp));
    if(myArea<1)
%         Areas major than the maximal surface expected in scene will be splitted


        [x y z] = createPlaneFromModel(xp, yp, zp, A, B, C, D)
        figure,
            pcshow(pcRef)
            hold on
            pcshow(ptCloud{i+1},'MarkerSize', 50)
            hold on
            surf(x,y,z) %Plot the surface
            xlabel 'x'
            ylabel 'y'
            zlabel 'z'
%             axis([0 1 0 0.5 0 2.5])
            view(-10,-70)
            title (['plane with volume: ' num2str(myArea)])
            pause(1)
    end
end
return
figure,
hold on
for i=0:maxI
    fileName{i+1}=[in_path num2str(scene) '/inliers_planeModel_' num2str(i) '.ply'];
    ptCloud{i+1} = pcread(fileName{i+1});
     ptCloud{i+1} = pcdenoise(ptCloud{i+1});
    x=double(ptCloud{i+1}.Location(:,1));
    y=double(ptCloud{i+1}.Location(:,2));
    z=double(ptCloud{i+1}.Location(:,3));
    myArea=(max(x)-min(x))*(max(y)-min(y));

    if(myArea<1)%Filtering ground planes. All faces in the boxes have area less than 1mt2
        % load coeffs of plane model

        eval('coeffs=load([in_path num2str(scene) ''/coeff'' num2str(i) ''.txt'']);');
        A=coeffs(1);
        B=coeffs(2);
        C=coeffs(3);
        D=coeffs(4);
        x=[min(x) max(x) ; min(x) max(x)];
        y=[min(y) min(y); max(y) max(y) ];
        z = -1/C*(A*x + B*y + D); % Solve for z data
    %     figure,
            pcshow(ptCloud{i+1},'MarkerSize', 20)
            hold on
            surf(x,y,z) %Plot the surface
            xlabel 'x'
            ylabel 'y'
            zlabel 'z'
            axis([-1 1 -1 1 0 3])
            view(-10,-70)
    end
    grid on
end
