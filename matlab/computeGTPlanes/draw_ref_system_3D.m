function draw_ref_system_3D(ang,Px,ind)
% ang in radians.. i guess
% Px as row vector
% ind as integer
scale=100/1000;
width=2/1000;
T=[[cos(ang);sin(ang);0],[cos(ang+pi/2);sin(ang+pi/2);0],[0;0;1],Px';[0 0 0 1]];
dibujarsistemaref(T,ind,scale,width);