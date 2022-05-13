function pcout=myEuclideanfilterv2(pcin,k)
%myEuclideanfilter Discard outliers based on Euclidean distance





x=pcin.Location(:,1);
y=pcin.Location(:,2);
z=pcin.Location(:,3);
% compute euclidean distance for each point
for i=1:length(x)
    euc_distance(i)=norm( zeros(1,3) - [x(i) y(i) z(i)] ) ;
end
% cluster by distance, 3 clusters
ii = kmeans(euc_distance',k);

myColor(1,:)=[1 1 0];
myColor(2,:)=[1 0 1];
myColor(3,:)=[0 1 1];
myColor(4,:)=[1 1 1];

for i=1:k
    xyz=[x(ii==i) y(ii==i) z(ii==i)];
    pc1=pointCloud(xyz);
%     eval(['pc' num2str(i) '=pointCloud(xyz);'])
    pc1.Color=uint8(repmat(myColor(i,:),pc1.Count,1));
%     eval(['pc' num2str(i) '.Color=uint8(repmat(myColor(' num2str(i) ',:),pc' num2str(i) '.Count,1));']);
    setPC{i}=pc1;
end


figure,
pcshow(pcin,'MarkerSize', 40)
hold on
for i=1:k
    pcshow(setPC{i},'MarkerSize', 30)
    hold on
end
% pcshow(pc1,'MarkerSize', 30)
% hold on
% pcshow(pc2,'MarkerSize', 20)
% hold on
% pcshow(pc3,'MarkerSize', 10)

% select pc with more points to return
pcout=pc1;
for (i=1:k)
%     pcTempCount=pci.Count;
    pcTempCount=setPC{i}.Count;
%     eval(['pcTempCount=pc' num2str(i) '.Count;'])
    if(setPC{i}.Count<pcTempCount)
%         pcout=pci;
%         eval(['pcout=pc' num2str(i) ';'])
            pcout=setPC{i};
    end
end

return