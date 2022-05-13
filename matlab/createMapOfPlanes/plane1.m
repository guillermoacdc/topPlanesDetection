y=-2:.01:2;
 z=4-y.^2;
 numy=length(y); 
 % Constructing the vertices
 V=zeros(numy,3); 
 for iy=1:numy, 
     V(iy,:)=[0,y(iy),z(iy)];  % Vertices in the parabola 
     V(iy+numy,:)=[0,y(iy),0]; % Vertices in the y axis
 end
 % Constructing faces
 F=zeros(numy-1,4); for iy=1:numy-1, F(iy,:)=[iy,iy+1,iy+1+numy,iy+numy]; end
 patch('Vertices',V,'Faces',F)