function createPlot(R,N,mass,k)
% Plots the system
% Clears the figure 1
figure(1)
clf(1);

% Defines the axis
axis equal
axis([-R(end)-1 R(end)+1 -R(end)-1 R(end)+1]);
hold on;
for j = 1:N
    % Plots the masses
    plot(mass(j).position_x,mass(j).position_y,'Color','black','Marker','.','MarkerSize',10);
    % Add text defining which mass is which
    txt = sprintf("m_{%i}",j);
    text(mass(j).position_x,mass(j).position_y,txt,'FontSize',8);
end

% Checks if we have a range to plot
if k
    for i = k
        % Plots the springs between the masses
        for p = mass(i).connections
            line([mass(p).position_x mass(i).position_x], ...
                [mass(p).position_y mass(i).position_y], ...
                'LineStyle','-','color','black')
            % If only one mass is inputted into the range plot that mass with red text
            % and only it's connections
            if length(k) == 1
                txt = sprintf("m_{%i}",i);
                text(mass(i).position_x,mass(i).position_y,txt,'FontSize',8,'Color','r');
                line([mass(i).position_x mass(p).position_x], ...
                    [mass(i).position_y mass(p).position_y], ...
                    'LineStyle','-','color','black')
            end
        end
    end
end
end