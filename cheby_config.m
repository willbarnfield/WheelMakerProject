function [rims,mass,N,R] = cheby_config(rim_no)

starting_masses = 4; % Keep as 4!

for i = 1:rim_no
    rims(i) = Rim;
end
% Length of spring
l = 8;
R(1) = l/(2*sin(pi/starting_masses));

% Defines no of masses on each rim
N = 1;
j = 1;
for i = starting_masses:starting_masses+rim_no-1
    rims(j).mass_count = i;
    j = j + 1;
end
for i = 1:rim_no
    for j = 1:rims(i).mass_count
        N = N + 1; % N is index of central mass
    end
end

rims(1).starting_mass = 1;
rims(1).ending_mass = starting_masses;
for i = 2:rim_no
    rims(i).starting_mass = rims(i-1).starting_mass + rims(i-1).mass_count;
    rims(i).ending_mass = rims(i-1).ending_mass + rims(i).mass_count;
end

% Defining radius
for i = 2:rim_no
    R(i) = l ./ (2 .* sin(pi ./ rims(i).mass_count));
end

for j = 1:rim_no
    for i = 1:N
        mass(i) = Mass;
    end
end

p = 0;
for j = 1:rim_no
    for i = 1:rims(j).mass_count
        mass(i+p).position_x = R(j)*cos(2*pi*(i-1)/rims(j).mass_count); % x values
        mass(i+p).position_y = R(j)*sin(2*pi*(i-1)/rims(j).mass_count); % y values
    end
    p = p + rims(j).mass_count;
end

% Defines central mass
mass(N).position_x = 0;
mass(N).position_y = 0;

% Defining the masses connections
% connections for 1st mass and last mass on rim
p = 0;
for i = 1:rim_no
    mass(1+p).original_connections = [rims(i).mass_count+p 2+p];
    mass(rims(i).mass_count+p).original_connections = [1+p rims(i).mass_count+p-1];
    if i == 1
        mass(1+p).connections = [rims(i).mass_count+p 2+p N];
        mass(rims(i).mass_count+p).connections = [1+p rims(i).mass_count+p-1 N];
    else
        mass(1+p).connections = [rims(i).mass_count+p 2+p];
        mass(rims(i).mass_count+p).connections = [1+p rims(i).mass_count+p-1];
    end
    p = p + rims(i).mass_count;
end

% Defining central mass connections
mass(N).connections = 1:rims(1).mass_count;
mass(N).original_connections = 1:rims(1).mass_count;

% Connections for masses on rims
p = 0;
for j = 1:rim_no
    for i = 2:rims(j).mass_count-1
        q = i+p;
        if j == 1
            mass(q).original_connections = [q-1 q+1 N];
            mass(q).connections = [q-1 q+1 N];
        else
            mass(q).original_connections = [q-1 q+1];
            mass(q).connections = [q-1 q+1];
        end
    end
    p = p + rims(j).mass_count;
end


% Adding imperfect cheby connections
% inner going out
even_count = 1;
odd_count = 3;
for i = 1:rim_no-1
    % Adding Even imperfection
    if mod(rims(i).mass_count,2) == 0
        for j = rims(i).starting_mass:rims(i).ending_mass
            % (double connection)
            if j == rims(i).ending_mass - even_count
                mass(rims(i).ending_mass - even_count).connections = [mass(rims(i).ending_mass - even_count).connections, rims(i).ending_mass + even_count + 2, rims(i).ending_mass + even_count + 3];
                mass(rims(i).ending_mass + even_count + 2).connections = [mass(rims(i).ending_mass + even_count + 2).connections, rims(i).ending_mass - even_count];
                mass(rims(i).ending_mass + even_count + 3).connections = [mass(rims(i).ending_mass + even_count + 3).connections, rims(i).ending_mass - even_count];
            elseif j > rims(i).ending_mass - even_count
                mass(j).connections = [mass(j).connections, j + rims(i+1).mass_count];
                mass(j + rims(i+1).mass_count).connections = [mass(j + rims(i+1).mass_count).connections, j];
            else
                mass(j).connections = [mass(j).connections, j + rims(i).mass_count];
                mass(j + rims(i).mass_count).connections = [mass(j + rims(i).mass_count).connections, j];
            end

        end
        even_count = even_count + 1;
        % Adding odd rim connections
    else
        for j = rims(i).starting_mass:rims(i).ending_mass
            % (double connection)
            if j < rims(i).starting_mass + odd_count
                mass(j).connections = [mass(j).connections, j + rims(i).mass_count];
                mass(j + rims(i).mass_count).connections = [mass(j + rims(i).mass_count).connections, j];
            else
                mass(j).connections = [mass(j).connections, j + rims(i+1).mass_count];
                mass(j + rims(i+1).mass_count).connections = [mass(j + rims(i+1).mass_count).connections, j];
            end

        end
        odd_count = odd_count + 1;
    end
end

figure(1);
createPlot(R,N,mass,1:N)

end