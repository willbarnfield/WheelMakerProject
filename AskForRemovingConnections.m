function mass = AskForRemovingConnections(R,N,mass)
    createPlot(R,N,mass,1:N);
    fprintf("\n");
    fprintf("You may remove connections from masses 1-%i\n",N);
    m1 = input("Enter the mass you would like to remove connections from: ");
    fprintf("\n");

    fprintf("mass %i is currently connected to ", m1);

    g=sprintf('%d ', mass(m1).connections);
    fprintf('%s\n', g);
    fprintf("\n");

    createPlot(R,N,mass,m1);

    fprintf("You may remove masses from the above connections\n");
    m2 = input("Enter the connections you would like to remove: (can be a vector) ");
    fprintf("\n");

    mass = removeConnections(mass, m1, m2);

    % Plots again
    createPlot(R,N,mass,m1);

    if length(mass(m1).connections) == 0
        fprintf("Would you like to remove mass %i? ",m1)
        remove = input("('y'/'n') ","s");
        if strcmp(remove, 'y')
            mass(m1).position_x = 9999;
            mass(m1).position_y = 9999;

            % removing the connections to N (different case)
            idx = mass(N).connections == m1;
            mass(N).connections(idx) = [];

            idx = mass(N).original_connections == m1;
            mass(N).original_connections(idx) = [];

            createPlot(R,N,mass,0)
        end
    end