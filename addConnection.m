function mass = addConnection(mass, m1, m2)
% m1 is a scalar
% m2 is a vector
for i = m2
    % Condition to ensure the mass doesn't connect to itself
    if ismember(i, mass(m1).connections)
    else if m1 == i
    else
        mass(m1).connections = [mass(m1).connections, i];
        mass(i).connections = [mass(i).connections, m1];
    end
    end
end