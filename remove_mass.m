function mass = remove_mass(mass,k,threeD)

% Go thru the mass to remove's connections
for j = mass(k).connections
    % Go through each connected masses connections
    for p = 1:length(mass(j).connections)
        % When we reach that masses connection to the mass to be removed,
        % remove it
        if mass(j).connections(p) == k
            mass(j).connections(p) = [];
            break
        end
    end
end

mass(k).connections = k;
mass(k).position_x = 9999;
mass(k).position_y = 9999;
if threeD
    mass(k).position_z = 9999;
end
end