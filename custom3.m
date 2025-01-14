function [R,mass,rims,N,rim_no] = custom3(N)
rims = Rim;
rims.mass_count = N;
rims.starting_mass = 1;
rims.ending_mass = N;
rims.masses = 1:N;
rim_no = 1;
R = 1;
% mass='';
for i = 1:N
    mass(i) = Mass3;
    mass(i).mass_value = 1;
    mass(i).position_x = 0;
    mass(i).position_y = 0;
    mass(i).position_z = 0;
end
figure(1);
createPlot3(R,N,mass,1:N);
end