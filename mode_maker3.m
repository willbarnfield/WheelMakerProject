function mode_maker3(wd,lag,plotType,b,mass,rim_no,R,modes)
% plotType can take different plot styles which can be more efficient
% lag will leave the springs when plotting which can create a nice effect

% Go to selected working directory
cd(wd);
disp(wd)
% Find modes, frequencies then sort smallest to largest
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
% c1 = [1, 0, 0];
% c2 = [0, 0.27, 0.8];
% colors_gradient = [linspace(c1(1),c2(1),rim_no)', linspace(c1(2),c2(2),rim_no)', linspace(c1(3),c2(3),rim_no)'];

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


for w = modes
    figure(f3)
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


        % % Plots the colour blocks
        % if plotType == 1
        %     for g = rim_no:-1:1
        %         check = rims(g).starting_mass:rims(g).ending_mass;
        %         xMode = [];
        %         yMode = [];
        %         zMode = [];
        %         for r = check
        %             if mass(r).position_x == 9999 || mass(r).position_y == 9999 || mass(r).position_z == 9999
        %             else
        %                 xMode = [xMode, r];
        %                 yMode = [yMode, r];
        %                 zMode = [zMode, r];
        %             end
        %         end
        %         x = Mode(xMode,1);
        %         y = Mode(yMode,2);
        %         z = Mode(zMode,3);
        %         % fill(x,y,cmap(g,:))
        %         % fill(x,y,cmap(g))
        %         fill(x,y,colors_gradient(g,:))
        %         hold on;
        %     end
        % elseif plotType == 2
        %     % Plots with all the springs
        %     if ~lag
        %         scatter3(Mode(1:end,1),Mode(1:end,2),Mode(1:end,3),10,'filled','MarkerFaceColor','black');
        %     end
        %     % Plots the faces
        %     % patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
        %     for k = 1:N
        %         for i = mass(k).connections(1:end)
        %             line([mass(k).mode_x mass(i).mode_x], ...
        %                 [mass(k).mode_y mass(i).mode_y], ...
        %                 [mass(k).mode_z mass(i).mode_z], ...
        %                 'LineStyle','-','color','black')
        %             hold on;
        %         end
        %     end
        %
        %     % Plots with the central springs
        %     % for k = mass(N).connections
        %     %     line([mass(N).mode_x mass(k).mode_x], [mass(N).mode_y mass(k).mode_y],'LineStyle','-','color','black')
        %     % end
        % elseif plotType == 3
        %     if ~lag
        %         scatter3(Mode(:,1),Mode(:,2),Mode(:,3),10,'filled','MarkerFaceColor','black');
        %     end
        %     % patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
        %     for k = 1:N
        %         for i = mass(k).original_connections
        %             line([mass(k).mode_x mass(i).mode_x], ...
        %                 [mass(k).mode_y mass(i).mode_y], ...
        %                 [mass(k).mode_z mass(i).mode_z], ...
        %                 'LineStyle','-','color','black')
        %             hold on;
        %         end
        %     end
        % end

        scatter3(Mode(1:end,1),Mode(1:end,2),Mode(1:end,3),10,'filled','MarkerFaceColor','black');
        % Plots the faces
        % patch ('Vertices',  vertices,  'Faces',  faces, 'FaceColor',  [1.0, 0.7, 0.0], 'EdgeColor',   [0.1, 0.1, 0.1], 'FaceAlpha',  0.7);
        for k = 1:N
            for i = mass(k).connections(1:end)
                line([mass(k).mode_x mass(i).mode_x], ...
                    [mass(k).mode_y mass(i).mode_y], ...
                    [mass(k).mode_z mass(i).mode_z], ...
                    'LineStyle','-','color','black')
                hold on;
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
cd("..")
end