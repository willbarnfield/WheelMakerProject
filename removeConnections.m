function mass = removeConnections(mass, m1, m2)
% Iterates through the inputted mass vector
for i = m2
    % If the mass in the vector is in mass one, remove it.
    if ismember(i, mass(m1).connections)
        idx = mass(m1).connections == i;
        mass(m1).connections(idx) = [];

        idx = mass(m1).original_connections == i;
        mass(m1).original_connections(idx) = [];

        idx = mass(i).connections == m1;
        mass(i).connections(idx) = [];

        idx = mass(i).original_connections == m1;
        mass(i).original_connections(idx) = [];
    end
end
end