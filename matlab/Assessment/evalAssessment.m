clc
close all
clear all
th=0.2;
t=2;
scenes=[1 6 7 29];
for i=1:length(scenes)
    [DP, MP, MD, SP, totalPlanes] = AssessmentFcn(scenes(i), t, th);
    results(i,:)=[DP, MP, MD, SP, totalPlanes];
end

T=table(scenes', results)