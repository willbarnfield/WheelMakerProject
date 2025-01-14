function mode_maker(wd,lag,plotType,b,mass,rim_no,R,modes)
% plotType can take different plot styles which can be more efficient
% lag will leave the springs when plotting which can create a nice effect

% Go to selected working directory
cd(wd);

% Find modes, frequencies then sort smallest to largest
[v,eigvals] = eig(b);
omega = real(diag(sqrt(-eigvals)));
[omega, idx] = sort(omega);
v2 = zeros(length(v));

% Sort modes
for ii=1:length(v)
    v2(:,idx(ii,1)) = v(:,ii);
end
N = length(eigvals)/2;

% Create a figure window
set(0,'DefaultFigureWindowStyle','normal');
f3 = figure('Name','Displacements');

% Define colors for the fill plotType
% Random colors
% cmap = rand(rim_no, 3);

% Color gradient
% cmap = hsv(rim_no);

% user-defined color gradient
c1 = [1, 0, 0];
c2 = [0, 0.27, 0.8];
colors_gradient = [linspace(c1(1),c2(1),rim_no)', linspace(c1(2),c2(2),rim_no)', linspace(c1(3),c2(3),rim_no)'];

% Get the initial positions to make the animations
for i = 1:N
    initpos(i,1) = mass(i).position_x;
    initpos(i,2) = mass(i).position_y;
end
initpos = reshape(initpos,2*N,1);

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

% Number of frames for the gif
T=20;
figure(f3)

% Go through user selected modes
for w = modes
    % if lag
    %     clf(f3);
    % end
    % m is for movie frames
    m=1;
    for j=1:T
        % Sets up the modes ready to be plotted
        eigmodet = real(exp(1i.*2.*j.*pi./T).*v2);
        Newpos = eigmodet(:,w)+initpos;
        Mode = reshape(Newpos,[],2);

        % Assigns the modes to the mass objects
        % Note: this isn't the most efficient method but it's the most
        % readable
        for k = 1:N
            mass(k).mode_x = Mode(k,1);
            mass(k).mode_y = Mode(k,2);
        end

        % % Plots the colour blocks
        % if plotType == 1
        %     for g = rim_no:-1:1
        %         % Go down plotting biggest rim first
        %         check = rims(g).starting_mass:rims(g).ending_mass;
        %         xMode = [];
        %         yMode = [];
        %         for r = check
        %             % Only plot masses that 'exist'
        %             if mass(r).position_x == 9999 || mass(r).position_y == 9999
        %             else
        %                 xMode = [xMode, r];
        %                 yMode = [yMode, r];
        %             end
        %         end
        %         x = Mode(xMode,1);
        %         y = Mode(yMode,2);
        %         % fill(x,y,cmap(g,:))
        %         % fill(x,y,cmap(g))
        %         fill(x,y,colors_gradient(g,:))
        %         hold on;
        %     end
        % elseif plotType == 2
        %     % Plots with all the springs
        %     if ~lag
        %         % Plots masses
        %         scatter(Mode(:,1),Mode(:,2),10,'filled','MarkerFaceColor','black');
        %     end
        %     for k = 1:N
        %         for i = mass(k).connections
        %             % Plots springs
        %             line([mass(k).mode_x mass(i).mode_x], ...
        %                 [mass(k).mode_y mass(i).mode_y], ...
        %                 'LineStyle','-','color','black')
        %             hold on;
        %         end
        %     end
        % elseif plotType == 3
        %     % This plot is just for the rims
        %     if ~lag
        %         scatter(Mode(:,1),Mode(:,2),10,'filled','MarkerFaceColor','black');
        %     end
        %     for k = 1:N
        %         for i = mass(k).original_connections
        %             line([mass(k).mode_x mass(i).mode_x], ...
        %                 [mass(k).mode_y mass(i).mode_y], ...
        %                 'LineStyle','-','color','black')
        %             hold on;
        %         end
        %     end
        % end
        scatter(Mode(:,1),Mode(:,2),10,'filled','MarkerFaceColor','black');
        for k = 1:N
            for i = mass(k).connections
                % Plots springs
                line([mass(k).mode_x mass(i).mode_x], ...
                    [mass(k).mode_y mass(i).mode_y], ...
                    'LineStyle','-','color','black')
                hold on;
            end
        end
        
        % % Plot the text displaying the eigenfrequency (removed)
        % txttplot = sprintf('\\omega = %1.2f',omega(w));
        % text(R(end)-0.8,R(end),txttplot,'Fontsize',10);
 
        % Label axis and get the current frame to store so it can be saved
        % to a gif later
        axis equal
        axis([-R(end)-1 R(end)+1 -R(end)-1 R(end)+1]);
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
    % Write the animation to a gif
    filename = sprintf("Mode_%d.gif",w);
    filename_2 = sprintf("Mode_%d_final.jpeg",w);
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

% Create a cell matrix with all the modes and frequencies to be saved to a
% csv file
freqMatrix = cell(length(omega),2);
for j = 1:length(omega)
    modenumber = sprintf("Mode %i",j);
    freqMatrix(j,1) = {modenumber};
    freqMatrix(j,2) = {omega(j)};
end

writecell(freqMatrix,'EigenFrequencies.csv');
msgbox(["Finished creating animations."; ""; "Please see EigenFrequencies.csv for the frequencies"; "corresponding to each mode."],"Success")

% Goes back to the original folder
cd("..")
end