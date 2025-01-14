function createPlot3(R,N,mass,k)
figure(1)
clf(1);

for j = 1:N
    % Creates a 3D plot of the structure
    plot3(mass(j).position_x,mass(j).position_y,mass(j).position_z,'Color','black','Marker','.','MarkerSize',10);
    hold on;
    % Add text labelling each mass to the plot
    txt = sprintf("m_{%i}",j);
    text(mass(j).position_x,mass(j).position_y,mass(j).position_z,txt,'FontSize',8);
end

if k
    for i = k
        for p = mass(i).connections
            % Plot the springs between masses
            line([mass(p).position_x mass(i).position_x], ...
                [mass(p).position_y mass(i).position_y], ...
                [mass(p).position_z mass(i).position_z],...
                'LineStyle','-','color','black')
            if length(k) == 1
                % View an individual masses connections
                txt = sprintf("m_{%i}",i);
                text(mass(i).position_x,mass(i).position_y,mass(i).position_z,txt,'FontSize',8,'Color','r');
                line([mass(i).position_x mass(p).position_x], ...
                    [mass(i).position_y mass(p).position_y], ...
                    [mass(i).position_z mass(p).position_z],...
                    'LineStyle','-','color','black')
            end
        end
    end
end
axis equal
axis([-R(end)-1 R(end)+1 -R(end)-1 R(end)+1 -R(end)-1 R(end)+1]);
end