function [faces,R,mass,rims,N,rim_no] = tetrahedron
% Tetrahedron
% Defines number of masses
N = 5;
R = 1;
rims = Rim;
rims.mass_count = N;
rims.starting_mass = 1;
rims.ending_mass = N;
rims.masses = 1:N;
rim_no = 1;
% Creates N Mass3 objects in a mass vector
for i = 1:N
    mass(i) = Mass3;
    mass(i).mass_value = 1;
end

rt2 = sqrt(2);

vertices = [
    1,0,-1/rt2;
    -1,0,-1/rt2;
    0,1,1/rt2;
    0,-1,1/rt2;
    0,0,0];

for j = 1:length(vertices)
    mass(j).position_x = vertices(j,1);
    mass(j).position_y = vertices(j,2);
    mass(j).position_z = vertices(j,3);
end

faces = [2,3,4;
    1,3,4;
    1,2,4;
    1,2,3];

% Defines the connections of each mass
mass(1).connections = [2,3,4,5];
mass(2).connections = [1,3,4,5];
mass(3).connections = [1,2,4,5];
mass(4).connections = [1,2,3,5];
mass(5).connections = [1,2,3,4];

figure(1);
hold on;
axis equal;
createPlot3(R,N,mass,1:N);
% patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
end