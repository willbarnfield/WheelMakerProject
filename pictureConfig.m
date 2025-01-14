function [R,mass,rims,N,rim_no] = pictureConfig(M)
% count = 0;
% imgArray = imread(img);
% imgLength = length(imgArray);


positions = [];
% for j = 1:imgLength
%     for i = 1:imgLength
%         % check rgb values all 0
%         if imgArray(i,j,1) < 10 && imgArray(i,j,2) < 10 && imgArray(i,j,3) < 10
%             % fprintf("Found black\n");
%             count = count + 1;
%             positions(count,1) = j;
%             positions(count,2) = -i;
%         end
%     end
% end
% halfLength = round(imgLength/2);
%
% positions(:,2) = positions(:,2) + halfLength;
% positions(:,1) = positions(:,1) - halfLength;
fig = figure(10);
clf(10)
axis([-1,1,-1,1])
hold on
% positions = zeros(M,2);
for i = 1:M
    [positions(i,1), positions(i,2)] = ginput(1);
    plot(positions(:,1),positions(:,2),'MarkerSize',20,'Marker','.','LineStyle','none',Color='k')
end

% figure(1)
% axis equal
% scatter(positions(:,1),positions(:,2),"black","filled")

N = length(positions(:,1));
% Check spring lengths are greater than 1 and if not make all the lengths
% bigger, use trig to get hypotenuse
% Check by sorting with x values

% Positions are vectors
h = 1;
for j = 1:N-1
    for k = j+1:N
        diff = positions(j,:) - positions(k,:);   
        h = min(h,norm(diff));
    end
end

move_vector=sum(positions)./N;
positions = positions - move_vector;

if h < 1
    % Spread masses out
    positions = positions ./ h;
end

% Sets up outputs to be used for calculations
R = max(max(positions)) + 0.5;
rims = Rim;
rims.mass_count = N;
rims.starting_mass = 1;
rims.ending_mass = N;
rims.masses = 1:N;
rim_no = 1;
for i = 1:N
    mass(i) = Mass;
    mass(i).mass_value = 1;
    mass(i).position_x = positions(i,1);
    mass(i).position_y = positions(i,2);
end
close(fig)
figure(1);
createPlot(R,N,mass,1:N);

end