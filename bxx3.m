function b = bxx3(N,mass)
b = zeros(length(mass));
for i = 1:N
    for j = mass(i).connections
        t = ((mass(j).position_x - mass(i).position_x) /...
            sqrt((mass(j).position_x - mass(i).position_x)^2 + (mass(j).position_y - mass(i).position_y)^2 + (mass(j).position_z - mass(i).position_z)^2))^2;

        b(i,i) = b(i,i) - t;
        b(i,j) = t;
    end
end
end