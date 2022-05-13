function ptTemp=extractPoint(pcRef,ind_model)
%EXTRACTPOINT Summary of this function goes here
%   Detailed explanation goes here
    xp=double(pcRef.Location(:,1));
    yp=double(pcRef.Location(:,2));
    zp=double(pcRef.Location(:,3));
    
    xp=xp(ind_model);
    yp=yp(ind_model);
    zp=zp(ind_model);
    
    ptTemp=pointCloud([xp yp zp]);

end

