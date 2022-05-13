function pc1=myMADfilter(pcin)
%MAD_discard Discard outliers based on the MAD criterion
% The outliers in the data are removed based on the median absolute 
% deviation (MAD) with criterion defined in (Varanasi and Devu, 2016)




x=pcin.Location(:,1);
y=pcin.Location(:,2);
z=pcin.Location(:,3);
% compute euclidean distance for each point
for i=1:length(x)
    euc_distance(i)=norm( zeros(1,3) - [x(i) y(i) z(i)] ) ;
end
% cluster by distance, 3 clusters
ii = kmeans(euc_distance',3);

% separate pc on clusters
xyz=[x(ii==1) y(ii==1) z(ii==1)];
pc1=pointCloud(xyz);
pc1.Color=uint8(repmat([1 1 0],pc1.Count,1));%yellow

xyz=[x(ii==2) y(ii==2) z(ii==2)];
pc2=pointCloud(xyz);
pc2.Color=uint8(repmat([1 0 1],pc2.Count,1));%magenta

xyz=[x(ii==3) y(ii==3) z(ii==3)];
pc3=pointCloud(xyz);
pc3.Color=uint8(repmat([0 1 1],pc3.Count,1));%cyan

% figure,
pcshow(pcin,'MarkerSize', 40)
hold on
pcshow(pc1,'MarkerSize', 30)
hold on
pcshow(pc2,'MarkerSize', 20)
hold on
pcshow(pc3,'MarkerSize', 10)



return
x=pcin.Location(:,:,1);
y=pcin.Location(:,:,2);
z=pcin.Location(:,:,3);

data=[x(:) y(:) z(:)];

b=1.4826;
% compute MAD
MAD=b*median(abs(data-median(data)));

k=1;
for i=1:length(data)
    if(abs(data(i)-median(data))<=3*MAD)
       newData(k)=data(i);
       k=k+1;
    end
end

if (isempty(newData))
    disp('Take care. Suppresion of data')
end
% register number of outliers detected
Noutliers=length(data)-length(newData);

end
% 