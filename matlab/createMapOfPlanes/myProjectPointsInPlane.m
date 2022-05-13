function pc2=myProjectPointsInPlane(x,y,z,A,B,C,D)

% solution base don https://stackoverflow.com/questions/9605556/how-to-project-a-point-onto-a-plane-in-3d

% compute distance btween point and plane
for i=1:length(x)
    d1(i)=[A B C]*[x(i) y(i) z(i)]';
end


% transform points by the computed distance in the normal direction of
% plane
for i=1:length(x)
    xyz(i,:)=[x(i) y(i) z(i)]-d1(i)*[A B C];
end

% comparison of points
% pc1=pointCloud([x y z]);
pc2=pointCloud(xyz);

% figure,
% pcshow(pc1,'MarkerSize', 30)
% figure,
% pcshow(pc2,'MarkerSize', 30)

