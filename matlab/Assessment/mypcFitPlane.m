function model=mypcFitPlane(pc_in,j)
%MYPCFITPLANE Summary of this function goes here
%   Detailed explanation goes here

x=pc_in.Location(:,1);
y=pc_in.Location(:,2);
z=pc_in.Location(:,3);
index=[1 length(x)/2 length(x)];
for i=1:3
    p(i,:)=[x(index(i)) y(index(i)) z(index(i))];
end
% vector 1 en el plano
v1=p(1,:)-p(2,:);
% vector 2 en el plano
v2=p(1,:)-p(3,:);
% vector normal entre 1 y 2
model=[cross(v1,v2)];

%                 figure,
%                 pcshow(pc_in,'MarkerSize',40)%ground truth
%                 hold on
%                 plot3(pc_in.Location(1,1),pc_in.Location(1,2) ,pc_in.Location(1,3) ,'d')
%                 quiver3(pc_in.Location(1,1),pc_in.Location(1,2) ,pc_in.Location(1,3),model(1),model(2),model(3),10);
%                 hold on
%                 title(['gt plane model - Box' num2str(j) ' Points: ' num2str(pc_in.Count)])

end

