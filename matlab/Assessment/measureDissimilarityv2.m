function [d_area d_orien d_dist] =measureDissimilarityv2(pc_i, pc_gt,n_i,n_gt)
%MEASURESIMILARITY Summary of this function goes here
%   Detailed explanation goes here

%% compute areas
% area of predicted model
        xp=double(pc_i.Location(:,1));
        yp=double(pc_i.Location(:,2));
        zp=double(pc_i.Location(:,3));
        [x y z] = createPlaneFromModel(xp, yp, zp, n_i(1), n_i(2), n_i(3), n_i(4));
        Area_i=(x(1,2)-x(1,1))*(y(2,1)-y(1,1));

        xp_gt=double(pc_gt.Location(:,1));
        yp_gt=double(pc_gt.Location(:,2));
        zp_gt=double(pc_gt.Location(:,3));
        [x_gt y_gt z_gt] = createPlaneFromModel(xp_gt, yp_gt, zp_gt, n_gt(1), n_gt(2), n_gt(3), n_gt(4));
        Area_gt=(x_gt(1,2)-x_gt(1,1))*(y_gt(2,1)-y_gt(1,1));
        depth=min([(x_gt(1,2)-x_gt(1,1)) (y_gt(2,1)-y_gt(1,1))]);
        
        d_area=abs(Area_gt-Area_i)/(Area_gt);%mejorar el cálculo de Area_gt; traer dato desde anotaciones
%         d_orien=abs(computeAngleBtwnVectors([1 0 0],n_gt(1:3) ) - computeAngleBtwnVectors([1 0 0],n_i(1:3) ))/computeAngleBtwnVectors([1 0 0],n_gt(1:3) );
        for i=1: length(xp)
            distance2(i)=dot([xp(i) yp(i) zp(i)]-[xp_gt(1) yp_gt(1) zp_gt(1)],n_gt(1:3));
        end
        d_orien=mean(distance2);

        meanpci=mean([xp yp zp]);
        meanpc_gt=mean([xp_gt yp_gt zp_gt]);
        d_dist=norm(meanpc_gt-meanpci)/depth;
        d_dist=(d_dist>0.5);%less than 50% of the depth is accepted
        return
% https://www.mathworks.com/matlabcentral/answers/371665-distance-from-point-to-plane-plane-was-created-from-3d-point-data
xi=pc_i.Location(:,1);
yi=pc_i.Location(:,2);
zi=pc_i.Location(:,3);

xj=pc_j.Location(:,1);
yj=pc_j.Location(:,2);
zj=pc_j.Location(:,3);
meanpci=mean([xi yi zi]);
meanpcj=mean([xj yj zj]);

distance1=norm(meanpci-meanpcj);


end

