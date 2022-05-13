function [labelName] = labelID2labelName(labelID, LabelDescriptor)
%LABELID2LABELNAME Summary of this function goes here
%   Detailed explanation goes here
labelName={};

k=0;
for i=1:length(labelID)
    k=k+1;
    if (labelID(i)==0)
        labelName{k}='NonLabeled';
    else
        labelName{k}=LabelDescriptor.Name{labelID(i)};
    end    
    


end

