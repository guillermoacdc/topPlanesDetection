function dd=computeMinHeightDistance(T)

A=table2array(T)
A=(A(:,2))

d(1)=abs(A(1)-A(2));
d(2)=abs(A(1)-A(3));
d(3)=abs(A(1)-A(4));

d(4)=abs(A(2)-A(3));
d(5)=abs(A(2)-A(4));

d(6)=abs(A(3)-A(4));

d=sort(d);

for i=1:length(d)
    if(d(i)~= 0)
        dd= d(i);
        return
    end
    
end
