function dibujarsistemaref (T,ind,scale,width)
R=T(1:3,1:3);
d=T(1:3,4);
fs=12;

p0x=R(1:3,1).*scale + d;
p0y=R(1:3,2).*scale + d;
p0z=R(1:3,3).*scale + d;

colorx=[1 0 0];
colory=[0 1 0];
colorz=[0 0 1];

dibujarlinea(d, p0x, colorx,width)
dibujarlinea(d, p0y, colory,width)
dibujarlinea(d, p0z, colorz,width)

% draw_cylinder(T,0.1);

labelx=strcat('X_{',num2str(ind),'}');
labely=strcat('Y_{',num2str(ind),'}');
labelz=strcat('Z_{',num2str(ind),'}');

p0x=double(p0x);
p0y=double(p0y);
p0z=double(p0z);

text(double(p0x(1,1)), p0x(2,1), p0x(3,1), labelx,'FontSize',fs);
text(p0y(1,1), p0y(2,1), p0y(3,1), labely,'FontSize',fs);
text(p0z(1,1), p0z(2,1), p0z(3,1), labelz,'FontSize',fs);

grid on;
end
