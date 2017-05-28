function [M, num, E] = ising(N,T)
J = 1;  % Strength of interaction (Joules)
k = 1;  % Joules per kelvin
Ms = [];
Es = [];
%% Generate a random initial configuration
grid = (rand(N) > 0.5)*2 - 1;
%% Evolve the system for a fixed number of steps
for i=1:500,
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
    transitions = (rand(N) < p_trans ).*(rand(N) < 0.1) * -2 + 1;
    % Perform the transitions
    grid = grid .* transitions;
    % Sum up our variables of interest
    M = sum(sum(grid));
    E = -sum(sum(DeltaE))/2;
    % Display the current state of the system (optional)
    image((grid+1)*128);
    xlabel(sprintf('T = %0.2f, M = %0.2f, E = %0.2f', T, M/N^2, E/N^2));
    set(gca,'YTickLabel',[],'XTickLabel',[]);
    axis square;    colormap bone;    drawnow;
end
% Count the number of clusters of ?spin up? states
[L, num] = bwlabel(grid == 1, 4);