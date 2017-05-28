function [M,grid, E] = Ising_evolution(N,J,T,EvolutionSpeedController,figureTrack)
display(figureTrack)
%global figureTrack
k = 1;  % The Boltzmann Constant in unit Joules per kelvin
%figureTrack=1;
%% Generate square lattice with 400 particles and assign
%% random orientation
grid = (rand(N) > 0.5)*2 - 1;
%% Evolution of system for fixed iteration
% The number of iteration as been increased because we are interating over
% changing T and J 
for i=1:5000
    % Calculate the number of neighbors of each cell
    neighbors = circshift(grid, [ 0  1]) + ...
        circshift(grid, [ 0 -1]) + ...
        circshift(grid, [ 1  0]) + ...
        circshift(grid, [-1  0]);
    % Calculate the change in energy of flipping a spin
    DeltaE = 2 * J * (grid .* neighbors);
    % Calculate the transition probabilities
    p_trans = exp(-DeltaE/(k * T));
    % Decide which transitions will occur
    transitions = (rand(N) < p_trans ).*(rand(N) < EvolutionSpeedController ) * -2 + 1;
    % Perform the transitions
    grid = grid .* transitions;
    % Sum up our variables of interest
    M = sum(sum(grid));
    E = -sum(sum(DeltaE))/2;
    % Display the current state of the system (optional)
    if i == 1
        
        figure(figureTrack)
        %display(figureTrack);
        %figure('initial','Evolution of System');
        image((grid+1)*128);
        %imwrite((grid+1)*128,sprintf('%d.jpg',i))
        xlabel(sprintf('T = %0.2f, M = %0.2f, E = %0.2f,EvolutionSpeedController=%0.2f', T, M/N^2, E/N^2,EvolutionSpeedController));
        set(gca,'YTickLabel',[],'XTickLabel',[]);
        axis square;    colormap bone;    drawnow;
        figureTrack = figureTrack+1;
        hold on;
       % continue
     elseif i ==5000
        figure(figureTrack)
        %display(figureTrack);
        hold on;
        %figure(' After 500 Iterations','Evolution of System');
        image((grid+1)*128);
        
        xlabel(sprintf('T = %0.2f, M = %0.2f, E = %0.2f,EvolutionSpeedController=%0.2f', T, M/N^2, E/N^2,EvolutionSpeedController));
        set(gca,'YTickLabel',[],'XTickLabel',[]);
        axis square;    colormap bone;    drawnow; 
        figureTrack = figureTrack+1;
        display(figureTrack);
        %continue
     %else  
       % figureTrack=figureTrack+1;
        %continue
    end 
    
end
% Count the number of clusters of ?spin up? states
