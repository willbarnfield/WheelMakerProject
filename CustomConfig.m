function [R,mass,rims,N,rim_no] = CustomConfig
    N = input("How many masses would you like to have? "); % Uses N since that's the 'last' mass
    R = 1;
    rims = Rim;
    rims.mass_count = N;
    rims.starting_mass = 1;
    rims.ending_mass = N;
    rims.masses = 1:N;
    rim_no = 1;
    for i = 1:N
        mass(i) = Mass;
        mass(i).mass_value = 1;
        mass(i).position_x = 0;
        mass(i).position_y = 0;
    end
    figure(1);
    createPlot(R,N,mass,1:N);

    % Ask user to continue adding connections, masses or  changing
    % positions. 

    cont = true;
    choice = '';
    while(cont)
        % while(~(strcmp(choice,'m') || strcmp(choice,'p') || strcmp(choice,'end')))
            choice = input("\nWould you like to add another mass or change the positions of the masses ?\n Type 'm', 'p' or 'end' to continue: ","s");
    % end
        createPlot(R,N,mass,1:N);

        if strcmp(choice,'p')
            fprintf("\nYou can change the position of masses 1-%i\n",N);
            massChoice = input("Which mass's position would you like to change? ");
            createPlot(R,N,mass,massChoice);

            fprintf("\nThe current position of mass %i is [x,y] = [%i,%i]\n",massChoice,mass(massChoice).position_x,mass(massChoice).position_y);
            pos = input("Please enter the new position in vector form [x,y]: ");
            mass(massChoice).position_x = pos(1);
            mass(massChoice).position_y = pos(2);
            maxPos = max(abs(pos(1)),abs(pos(2)));

            if maxPos > R
                R = maxPos;
            end

            createPlot(R,N,mass,massChoice);

        elseif strcmp(choice, 'm')
            noOfNewMasses = input("How many more masses would you like to add? ");

            N = N+noOfNewMasses;

            for i = rims.ending_mass+1:N
                mass(i) = Mass;
                mass(i).mass_value = 1;
                mass(i).position_x = 0;
                mass(i).position_y = 0;
            end

            rims.mass_count = N;
            rims.ending_mass = N;
            rims.masses = 1:N;
            createPlot(R,N,mass,1:N);

        elseif strcmp(choice,'end')
            cont = false;
        end
    end
end

