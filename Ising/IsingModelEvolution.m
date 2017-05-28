%Evolution of the system                        %
%-----------------------------------------------%
% Script to run tracking of the evolution of the 
% System over time 
n_grid=20;
EvolutionSpeedControllerList =[0.1,0.2,0.3];
%EvolutionSpeedControllerList =[0.1,0.2,0.3,0.4,0.5];
TList = [];
JList = [];
gridList=[];
n = 40;
l = 10;
out = randperm(n,l);
disp(out);
index =1;
for elem=EvolutionSpeedControllerList
    % Choose a temperature
    disp(elem)
    
    
    Track=out(index);
    disp(Track)
    %disp(Track)
    T = rand()*5+1e-9;
    %T = rand()*3+1e-10;
    disp(T)
    J = rand()+1e-10;
    
    % Perform a simulation
    [M,grid, E] = Ising_evolution(n_grid,J ,T,elem,Track);
    % Record the results
    
    TList = [TList T];
    JList = [JList J];
   
    %This bears the configurations. For which the probability distribution
    %is as diven by the Ising model (Pb)
    gridList = cat(3,gridList, grid);
    index=index+1;
    %figureTrack=figureTrack2;
end