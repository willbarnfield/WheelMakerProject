function mass = AskForMoreConnections(R,N,mass)
    createPlot(R,N,mass,1:N);
    fprintf("\n");
    fprintf("You may add connections to masses 1-%i\n",N);
    m1 = input("Enter the mass you would like to add connections to: ");
    fprintf("\n");

    fprintf("mass %i is currently connected to ", m1);

    g=sprintf('%d ', mass(m1).connections);
    fprintf('%s\n', g);
    fprintf("\n");

    createPlot(R,N,mass,m1);

    fprintf("You may connect to masses 1-%i\n",N);
    m2 = input("Enter the additional connections to make: (can be a vector) ");
    fprintf("\n");

    mass = addConnection(mass, m1, m2);
    % Plots again
    createPlot(R,N,mass,m1);
end