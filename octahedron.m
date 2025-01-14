function [faces,R,mass,rims,N,rim_no] = octahedron
% N = input("How many masses would you like to have? "); % Uses N since that's the 'last' mass
% Octahedron
N = 7;
R = 0.7;
rims = Rim;
rims.mass_count = N;
rims.starting_mass = 1;
rims.ending_mass = N;
rims.masses = 1:N;
rim_no = 1;
for i = 1:N
    mass(i) = Mass3;
    mass(i).mass_value = 1;
end

vertices = [1,0,0;
    -1,0,0;
    0,1,0;
    0,-1,0;
    0,0,1;
    0,0,-1;
    0,0,0];

for j = 1:length(vertices)
    mass(j).position_x = vertices(j,1);
    mass(j).position_y = vertices(j,2);
    mass(j).position_z = vertices(j,3);
end

% mass(1).position_x = 1;
% mass(1).position_y = 0;
% mass(1).position_z = 0;
% 
% mass(2).position_x = -1;
% mass(2).position_y = 0;
% mass(2).position_z = 0;
% 
% mass(3).position_x = 0;
% mass(3).position_y = 1;
% mass(3).position_z = 0;
% 
% mass(4).position_x = 0;
% mass(4).position_y = -1;
% mass(4).position_z = 0;
% 
% mass(5).position_x = 0;
% mass(5).position_y = 0;
% mass(5).position_z = 1;
% 
% mass(6).position_x = 0;
% mass(6).position_y = 0;
% mass(6).position_z = -1;
% 
% mass(7).position_x = 0;
% mass(7).position_y = 0;
% mass(7).position_z = 0;

% Connections
mass(1).connections = [5,6,3,4,7];
mass(2).connections = [5,6,3,4,7];
mass(3).connections = [5,6,2,1,7];
mass(4).connections = [5,6,1,2,7];
mass(5).connections = [1,3,2,4,7];
mass(6).connections = [1,3,2,4,7];
mass(7).connections = 1:6;

faces = [1,3,5;
    3,5,2;
    2,5,4;
    4,5,1;
    4,1,6;
    1,3,6;
    3,2,6;
    2,4,6];

figure(1);
hold on;
axis equal;
createPlot3(R,N,mass,1:N);
% patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
end