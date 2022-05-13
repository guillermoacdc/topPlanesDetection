function pcout=myEuclideanfilter(pcin)
%myEuclideanfilter Discard outliers based on Euclidean distance





x=pcin.Location(:,1);
y=pcin.Location(:,2);
z=pcin.Location(:,3);
% compute euclidean distance for each point
for i=1:length(x)
    euc_distance(i)=norm( zeros(1,3) - [x(i) y(i) z(i)] ) ;
end
% cluster by distance, 3 clusters
ii = kmeans(euc_distance',3);

myColor(1,:)=[1 1 0];
myColor(2,:)=[1 0 1];
myColor(3,:)=[0 1 1];
myColor(4,:)=[1 1 1];

for i=1:3
    xyz=[x(ii==i) y(ii==i) z(ii==i)];
%     pc1=pointCloud(xyz);
    eval(['pc' num2str(i) '=pointCloud(xyz);'])
%     pc1.Color=uint8(repmat(myColor(i,:),pc1.Count,1));
    eval(['pc' num2str(i) '.Color=uint8(repmat(myColor(' num2str(i) ',:),pc' num2str(i) '.Count,1));']);

end
% separate pc on clusters
% xyz=[x(ii==1) y(ii==1) z(ii==1)];
% pc1=pointCloud(xyz);
% pc1.Color=uint8(repmat([1 1 0],pc1.Count,1));%yellow
% 
% xyz=[x(ii==2) y(ii==2) z(ii==2)];
% pc2=pointCloud(xyz);
% pc2.Color=uint8(repmat([1 0 1],pc2.Count,1));%magenta
% 
% xyz=[x(ii==3) y(ii==3) z(ii==3)];
% pc3=pointCloud(xyz);
% pc3.Color=uint8(repmat([0 1 1],pc3.Count,1));%cyan

figure,
pcshow(pcin,'MarkerSize', 40)
hold on
pcshow(pc1,'MarkerSize', 30)
hold on
pcshow(pc2,'MarkerSize', 20)
hold on
pcshow(pc3,'MarkerSize', 10)

% select pc with more points to return
pcout=pc1;
for (i=1:3)
%     pcTempCount=pci.Count;
    eval(['pcTempCount=pc' num2str(i) '.Count;'])
    if(pcout.Count<pcTempCount)
%         pcout=pci;
        eval(['pcout=pc' num2str(i) ';'])
    end
end

return