function [rims,mass,N,R] = standard_config(M,rim_no)
N = rim_no*M + 1; % masses + 1 for center

% Defines which masses lie on which rim
p = 0;
for i = 1:rim_no
    rims(i) = Rim;
    rims(i).masses = p+1:M*i;
    rims(i).starting_mass = rims(i).masses(1);
    rims(i).ending_mass = rims(i).masses(end);
    p = p + M;
end

% Defines the radii
if M > 20
    R(1) = M./(4*pi);
else
    R(1) = M./(2*pi);
end

for i=2:rim_no
    R(i) = 1+R(i-1);
end

% Creates a vector of mass objects
for i = 1:N
    mass(i) = Mass;
end

% Sets the x and y positions of each mass
p = 0;
for j = 1:rim_no
    for i = 1:M
        mass(i+p).position_x = R(j)*cos(2*pi*(i-1)/M); % x values
        mass(i+p).position_y = R(j)*sin(2*pi*(i-1)/M); % y values
    end
    % Jumps to the next rim
    p = p + M;
end

% Defines central mass
mass(N).position_x = 0;
mass(N).position_y = 0;

% Defining the masses connections
% connections for 1st mass and last mass on rim
p = 0;
for i = 1:rim_no
    mass(1+p).original_connections = [M+p 2+p];
    mass(M+p).original_connections = [1+p M+p-1];
    if i == 1
        mass(1+p).connections = [M+p 2+p N];
        mass(M+p).connections = [1+p M+p-1 N];
    else
        mass(1+p).connections = [M+p 2+p];
        mass(M+p).connections = [1+p M+p-1];
    end
    p = p + M;
end

% Defining central mass connections
mass(N).connections = 1:M;
mass(N).original_connections = 1:M;

% Connections for masses on rims
p = 0;
for j = 1:rim_no
    for i = 2:M-1
        q = i+p;
        if j == 1
            mass(q).original_connections = [q-1 q+1 N];
            mass(q).connections = [q-1 q+1 N];
        else
            mass(q).original_connections = [q-1 q+1];
            mass(q).connections = [q-1 q+1];
        end

    end
    p = p + M;
end

% Connections between the rims
p = 0;
q = N;
for j = 1:rim_no-1
    for i = 1:M
        % inner rim going out
        mass(i+p).connections = [mass(i+p).connections , i+p+M];

        % Outer rim going in
        mass(q-i).connections = [mass(q-i).connections, q-i-M];
    end
    p = p + M;
    q = q - M;
end

% Plotting the springs
figure(1);
createPlot(R,N,mass,1:N);
end