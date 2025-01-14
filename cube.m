function [faces,R,mass,rims,N,rim_no] = cube
% Cube
N = 9;
R = 1;
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

vertices = [
    1,1,1;
    -1,1,1;
    1,-1,1;
    1,1,-1;
    -1,-1,-1;
    -1,-1,1;
    -1,1,-1;
    1,-1,-1;
    0,0,0];

for j = 1:length(vertices)
    mass(j).position_x = vertices(j,1);
    mass(j).position_y = vertices(j,2);
    mass(j).position_z = vertices(j,3);
end

% Connections
mass(1).connections = [2,4,3,9];
mass(2).connections = [1,7,6,9];
mass(3).connections = [6,8,1,9];
mass(4).connections = [1,7,8,9];
mass(5).connections = [6,8,7,9];
mass(6).connections = [3,5,2,9];
mass(7).connections = [5,2,4,9];
mass(8).connections = [3,5,4,9];
mass(9).connections = 1:8;

faces = [1,2,6,3;
    3,6,5,8;
    1,3,8,4;
    1,2,7,4;
    4,7,5,8;
    2,6,5,7];

figure(1);
hold on
axis equal;
createPlot3(R,N,mass,1:N);
% patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
end