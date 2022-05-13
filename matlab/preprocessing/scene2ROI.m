function [roi] = scene2ROI(scene)
%scene2ROI Returns a ROI that covers the four boxes in the scene
%   The ROI is a rectangular area defined by its four vertex [xmin xmax ymin ymax]

switch scene
    %Escenarios para Mov1
    case{2,4,18,36}
        roi=[-1,1,-0.5,0.5,1,3];%ok
    %Escenarios para Mov2
    case{1,6,7,29}
        roi=[-1,1,-0.5,0.5,0,3];%ok
    %Escenarios para Mov3
    case{5,23,30,33}
        roi=[-1,1,-0.5,1,1,3];%ok
    %Escenarios para Mov4
    case{11,16,24,26}
%         xmin=400;xmax=1200;ymin=300;ymax=800;%ok
    %Escenarios para Mov5
    case{3,20,21,31}
%         xmin=400;xmax=1200;ymin=300;ymax=900;%ok
    %Escenarios para Mov6
    case{9,14,17,27}
%         xmin=500;xmax=1200;ymin=250;ymax=900;%ok
    %Escenarios para Mov7
    case{8,10,12,28}
%         xmin=400;xmax=1250;ymin=300;ymax=900;%ok
    %Escenarios para Mov8
    case{13,15,34,35}
%        xmin=500;xmax=1200;ymin=350;ymax=1000;%ok
    %Escenarios para Mov9
    case{19,22,25,32}
%         xmin=600;xmax=1400;ymin=250;ymax=1000;%ok

% 
end

end
    
