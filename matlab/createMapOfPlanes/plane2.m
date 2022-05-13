
figure,
patch([1 -1 -1 1], [1 1 -1 -1], [0 0 0 0])


[x y] = meshgrid(-1:2:1); % Generate x and y data
z = ones(size(x, 1)); % Generate z data
figure,
surf(x, y, z) % Plot the surface
xlabel 'x'
ylabel 'y'
zlabel 'z'

figure,
A=0.489756;
B=0.386344;
C=0.781587;
D=-1.19887;
% [x y] = meshgrid(-1:2:1); % Generate x and y data
x=[-0.2262 -0.264 ; -0.1181 -0.2122];
y=[0.0729 -0.1951; 0.007459  -0.2614 ];
z = -1/C*(A*x + B*y + D); % Solve for z data
surf(x,y,z) %Plot the surface
xlabel 'x'
ylabel 'y'
zlabel 'z'