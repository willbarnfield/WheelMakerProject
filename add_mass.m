function [N,mass] = add_mass(N,mass,threeD)
% This assumes the central mass is at the end

% Set center mass to last mass
mass(N+1) = mass(N);


for p = 1:length(mass)
    % Get logical array if N is in it
    % a = mass(p).connections;
    b = mass(p).connections == N;
    % Find where the 1 is and set to new center
    for j = 1:length(b)
        if b(j)
            % a(j) = N+1;
            mass(p).connections(j) = N+1;
        end
    end
    % mass(p).connections = a;
end

% Create new mass
if threeD
    mass(N) = Mass3;
else
    mass(N) = Mass;
end
% mass(N) = Mass;
mass(N).mass_value = 1;
mass(N).position_x = 0;
mass(N).position_y = 0;
if threeD
    mass(N).position_z = 0;
end
mass(N).connections = [];

% Retain center mass being at the end
N = N+1;
end