function mass = change_mass_position3(k,mass,x,y,z)
% Here k is the mass to change
mass(k).position_x = x;
mass(k).position_y = y;
mass(k).position_z = z;
end