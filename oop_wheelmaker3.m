function oop_wheelmaker3

cont = true;
while(cont)

clearvars;
close all;
set(0,'DefaultFigureWindowStyle','docked');

type = '';
while (~(strcmp(type,'octahedron') || strcmp(type,'cube') || strcmp(type,'tetrahedron')))
    type = input("Which configuration would you like to use? ('cube', 'tetrahedron', 'octahedron') ","s");
end

fprintf("\n");
if strcmp(type,'octahedron')
    [faces,R,mass,rims,N,rim_no] = octahedron;
elseif strcmp(type,'cube')
    [faces,R,mass,rims,N,rim_no] = cube;
elseif strcmp(type,'tetrahedron')
    [faces,R,mass,rims,N,rim_no] = tetrahedron;
end

fprintf("\n");

% Check if mass should be removed or added?
check = true;
while (check)
    choice = '';
    while(~(strcmp(choice,'a') || strcmp(choice,'r') || strcmp(choice, 'c')))
        choice = input("Would you like to add a connection, remove a connection or use this configuration \n" + ...
        "Enter ('a' for add, 'r' for remove or 'c' for continue with this configuration\n","s");
    end
    if strcmp(choice, 'a')
        mass = AskForMoreConnections(R,N,mass);
    elseif strcmp (choice, 'r')
        mass = AskForRemovingConnections(R,N,mass);
    else 
        check = false;
        createPlot3(R,N,mass,1:N);
        fprintf("\n");
    end
end

saveConfig = input("Would you like to save this configuration image to your folder (defined later)? ('y'/'n') ","s");
fprintf("\n");


% Defining matrix b
b = [[bxx3(N,mass) ; bxy3(N,mass); bxz3(N,mass)], ...
    [bxy3(N,mass) ; byy3(N,mass) ; byz3(N,mass)], ...
    [bxz3(N,mass) ; byz3(N,mass) ; bzz3(N,mass)]];

b(isnan(b))=0;

check = true;
while (check)
    check = input("Would you like to change any of the mass values? ('y'/'n') ","s");
    fprintf("\n");
    if strcmp(check,'n')
        check = false;
    else
        fprintf("You may change the mass values of 1-%i (%i is the central mass)\n",N,N);
        m1 = input("Which mass would you like to change? ");
        fprintf("\n");

        fprintf("The current mass value of %i is %1.2f\n",m1,mass(m1).mass_value);
        m2 = input("What would you like to change the mass value to? ");
        fprintf("\n");
        mass(m1).mass_value = m2;
    end
end

for j=1:N
    b(i,:) = b(i,:) ./ mass(i).mass_value;
    b(i+N,:) = b(i,:) ./ mass(i).mass_value;
    b(i+2*N,:) = b(i,:) ./ mass(i).mass_value;
end

sparce = input("Would you like to see a matrix sparcity diagram? ('y'/'n') ","s");
saveSparce = false;
fprintf("\n")
if strcmp(sparce,'y')
    f2 = figure("Name","Matrix sparcity diagram");
    spy(b);
    saveSparce = input("Would you like to save this sparcity diagram to your folder (defined later)? ('y'/'n') ","s");
    fprintf("\n");
end

fprintf("There are %i different modes which would you like to see? (these will be saved automatically)\n",length(b))
view_modes = input("(Enter a vector): ");
fprintf("\n");
fprintf("What folder would you like to save the gifs to? format: 'folder' \n");
folder = input("Folder name: ","s");
fprintf("\n");

mkdir(folder);
oldfolder = cd(folder);

% Saving plot figure
if strcmp(saveConfig, 'y')
    saveas(1, 'Mass configureation','jpg');
end

% Save configuration variables
save("configuration.mat", "mass", "rims", "N", "R", "rim_no"); 

% Saving sparcity image
if strcmp(saveSparce,'y')
    saveas(f2,'Matrix sparcity','jpg')
end

% plotMasses = input("Would you like to plot the masses in the animations? ('y'/'n') ");
fprintf("\nWhat type of plot would you like? ('rims', 'springs', 'fill') ('springs' runs the slowest) \nNote: if you've removed a mass a few modes won't change\n")
plotType = input("Plot Type: ","s");
fprintf("\n");

lag = 'n';
if strcmp(plotType, 'springs') || strcmp(plotType, 'rims')
    lag = input("Would you like to see trails? ('y'/'n') ","s");
end

%%
% evals = eig(b);

[v,eigvals] = eig(b);
omega = real(diag(sqrt(-eigvals)));
[omega, idx] = sort(omega);
v2 = zeros(length(v));
for ii=1:length(v)
    v2(:,idx(ii,1)) = v(:,ii);
end
N = length(eigvals)/3;

    set(0,'DefaultFigureWindowStyle','normal');
    f3 = figure('Name','Displacements');

    % Random colors
    % cmap = rand(rim_no, 3);

    % Color gradient
    % cmap = hsv(rim_no);

    % user-defined color gradient
    c1 = [1, 0, 0];
    c2 = [0, 0.27, 0.8];
    colors_gradient = [linspace(c1(1),c2(1),rim_no)', linspace(c1(2),c2(2),rim_no)', linspace(c1(3),c2(3),rim_no)'];

        for i = 1:N
            initpos(i,1) = mass(i).position_x;
            initpos(i,2) = mass(i).position_y;
            initpos(i,3) = mass(i).position_z;
        end
        initpos = reshape(initpos,3*N,1);


    % Redefining variables for speed
    if strcmp(lag, 'y')
        lag = 1;
    else
        lag = 0;
    end

    if strcmp(plotType, 'fill')
        plotType = 1;
    elseif strcmp(plotType, 'springs')
        plotType = 2;
    elseif strcmp(plotType, 'rims')
        plotType = 3;
    end


    T=20;
    
    figure(f3)
    
    for w = view_modes
        if lag
            clf(f3);
        end

        m=1;
        for j=1:T
            % Finds the different modes
            eigmodet = real(exp(1i.*2.*j.*pi./T).*v2);
            Newpos = eigmodet(:,w)+initpos;
            Mode = reshape(Newpos,[],3);
            
            for k = 1:N
                mass(k).mode_x = Mode(k,1);
                mass(k).mode_y = Mode(k,2);
                mass(k).mode_z = Mode(k,3);
            end

            vertices = zeros(N-1,3);
            for k = 1:N-1
                vertices(k,1) = mass(k).mode_x;
                vertices(k,2) = mass(k).mode_y;
                vertices(k,3) = mass(k).mode_z;
            end
           
            
            % Plots the colour blocks
            if plotType == 1
                for g = rim_no:-1:1
                    check = rims(g).starting_mass:rims(g).ending_mass;
                    xMode = [];
                    yMode = [];
                    zMode = [];
                    for r = check
                        if mass(r).position_x == 9999 || mass(r).position_y == 9999 || mass(r).position_z == 9999
                        else
                            xMode = [xMode, r];
                            yMode = [yMode, r];
                            zMode = [zMode, r];
                        end
                    end
                    x = Mode(xMode,1);
                    y = Mode(yMode,2);
                    z = Mode(zMode,3);
                    % fill(x,y,cmap(g,:))
                    % fill(x,y,cmap(g))
                    fill(x,y,colors_gradient(g,:))
                    hold on;
                end
            elseif plotType == 2
                % Plots with all the springs
                if ~lag
                    scatter3(Mode(1:end,1),Mode(1:end,2),Mode(1:end,3),10,'filled','MarkerFaceColor','black');
                end
                % Plots the faces
                patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
                for k = 1:N
                    for i = mass(k).connections(1:end)
                        line([mass(k).mode_x mass(i).mode_x], ...
                            [mass(k).mode_y mass(i).mode_y], ...
                            [mass(k).mode_z mass(i).mode_z], ...
                            'LineStyle','-','color','black')
                        hold on;
                    end
                end     

                % Plots with the central springs
                % for k = mass(N).connections
                %     line([mass(N).mode_x mass(k).mode_x], [mass(N).mode_y mass(k).mode_y],'LineStyle','-','color','black')
                % end
            elseif plotType == 3
                if ~lag
                    scatter3(Mode(:,1),Mode(:,2),Mode(:,3),10,'filled','MarkerFaceColor','black');
                end
                patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
                 for k = 1:N
                    for i = mass(k).original_connections
                        line([mass(k).mode_x mass(i).mode_x], ...
                            [mass(k).mode_y mass(i).mode_y], ...
                            [mass(k).mode_z mass(i).mode_z], ...
                            'LineStyle','-','color','black')
                        hold on;
                    end
                 end 
            end
            
            axis equal
            axis([-R(end)-1 R(end)+1 -R(end)-1 R(end)+1 -R(end)-1 R(end)+1]);
            titlename = sprintf('Mode %d',w);
            title(titlename);
            mov(m,w)=getframe;
            m = m+1;
            hold off;
        end
        % Creates the gif files
        for ii = 1:length(mov(:,w))
            im{ii} = frame2im(mov(ii,w));
        end
        filename = sprintf("Mode%d.gif",w);
        filename_2 = sprintf("Mode%d_final.jpeg",w);
        for ii = 1:length(mov(:,w))
            [P,map] = rgb2ind(im{ii},256);
            if ii == 1
                imwrite(P,map,filename,"gif","LoopCount",Inf,"DelayTime",0.1);
            else
                imwrite(P,map,filename,"gif","WriteMode","append","DelayTime",0.1);
            end
        end
        imwrite(P,map,filename_2,"jpeg");
    end

    freqMatrix = cell(length(omega),2);
    for j = 1:length(omega)
        modenumber = sprintf("Mode %i",j);
        freqMatrix(j,1) = {modenumber};
        freqMatrix(j,2) = {omega(j)};
    end

writecell(freqMatrix,'EigenFrequencies.csv');
msgbox(["Finished creating animations."; ""; "Please see EigenFrequencies.csv for the frequencies"; "corresponding to each mode."],"Success")




    % Goes back to the original folder
    cd(oldfolder)

    cont = input("Would you like to create another configuration? ('y'/'n') ","s");
    if strcmp(cont,'y')
        cont = true;
    else
        cont = false;
    end
end

%% Function declarations

function mass = addConnection(mass, m1, m2)
% m1 is a scalar
% m2 is a vector
for i = m2
    if ismember(i, mass(m1).connections)
    elseif m1 == i
    else
        mass(m1).connections = [mass(m1).connections, i];
        mass(i).connections = [mass(i).connections, m1];
    end
end
end

function mass = removeConnections(mass, m1, m2)
for i = m2
    if ismember(i, mass(m1).connections)
        idx = mass(m1).connections == i;
        mass(m1).connections(idx) = [];

        idx = mass(m1).original_connections == i;
        mass(m1).original_connections(idx) = [];

        idx = mass(i).connections == m1;
        mass(i).connections(idx) = [];

        idx = mass(i).original_connections == m1;
        mass(i).original_connections(idx) = [];
    end
end
end

function mass = AskForMoreConnections(R,N,mass)
    createPlot3(R,N,mass,1:N);
    fprintf("\n");
        fprintf("You may add connections to masses 1-%i\n",N);
        m1 = input("Enter the mass you would like to add connections to: ");
        fprintf("\n");

        fprintf("mass %i is currently connected to ", m1);

        g=sprintf('%d ', mass(m1).connections);
        fprintf('%s\n', g);
        fprintf("\n");

        createPlot3(R,N,mass,m1);

        fprintf("You may connect to masses 1-%i\n",N);
        m2 = input("Enter the additional connections to make: (can be a vector) ");
        fprintf("\n");

        mass = addConnection(mass, m1, m2);
        % Plots again
        createPlot3(R,N,mass,m1);
end

function mass = AskForRemovingConnections(R,N,mass)
    createPlot(R,N,mass,1:N);
    fprintf("\n");
        fprintf("You may remove connections from masses 1-%i\n",N);
        m1 = input("Enter the mass you would like to remove connections from: ");
        fprintf("\n");

        fprintf("mass %i is currently connected to ", m1);

        g=sprintf('%d ', mass(m1).connections);
        fprintf('%s\n', g);
        fprintf("\n");

        createPlot(R,N,mass,m1);

        fprintf("You may remove masses from the above connections\n");
        m2 = input("Enter the connections you would like to remove: (can be a vector) ");
        fprintf("\n");

        mass = removeConnections(mass, m1, m2);

        % Plots again
        createPlot(R,N,mass,m1);

        if length(mass(m1).connections) == 0
            fprintf("Would you like to remove mass %i? ",m1)
            remove = input("('y'/'n') ","s");
            if strcmp(remove, 'y')
                mass(m1).position_x = 9999;
                mass(m1).position_y = 9999;
                mass(m1).position_z = 9999;

                % removing the connections to N (different case)
                idx = mass(N).connections == m1;
                mass(N).connections(idx) = [];

                idx = mass(N).original_connections == m1;
                mass(N).original_connections(idx) = [];

                createPlot(R,N,mass,0)
            end
        end
end


end


