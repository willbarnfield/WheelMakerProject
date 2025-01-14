# The Wheel Maker
#### Video Demo:  <https://youtu.be/jZX_9zZtyQM>
#### Description:
This app can be used to analyse various vibrational modes of discrete mass-spring systems constructed using linear springs. This description will just be a short outline of the features as there is a lot of underlying maths beneath the project that I won't go into!

A zip file is also included which has the app and can be played around with, just a warning it will take a while to install if you don't have MATLAB! (Note this has now been removed as the Zip file is too large to upload. The file is available upon request.)

## 2D
In the 2D section there are 4 configuration options.
<li>Standard

This is used to create the normal 'N-gon' structure, this can be seen from looking at an example. We can also add additional rims to this structure which can produce some even more unique modes.
<li>Cheby

This is a bit of a unique structure, it's got its name from Chebyshev polynomials due to a weird link between them and this configuration.
<li>Draw

This can be used to create custom configuration by clicking on the screen and placing masses where needed.
<li>Import

This final section is used to import configurations used previously.

## 3D
For this section we have 5 configuration options
### Platonic solids
These 3 will plot various platonic solids with an added central core
<li>Tetrahedron
<li>Cube
<li>Octahedron

### Other
<li>Import

This is similar to the 2D version
<li>Custom

This is how we can create custom configurations in 3D (with a variable number of masses)

## Shared features
### Mass Configurator
In this section you can select masses which are displayed on the screen (plot) and edit various features about them.
You can connect them to other masses, change their mass value, change their position or even add or remove more masses. Once you are happy with the selections you can set the connections and move onto the next section.

### Final options
Here we can look at the matrix sparsity which embodies the structure of the configuration. We can also create a directory for the animations we will make when looking at the various vibrational modes of the systems.

### Display modes
This is the final section where we can view a csv file which contains the modes and the frequencies which excite them. We can also view the gifs or static jpegs of the last position of the structure in the animation.

# Function files
This next section will go through the different functions involved in this project, there are a lot of them!
Many design choices were made throughout this project but deciding on using lots of functions and MATLAB app designer was a big one that allowed me to leverage its graphical capabilities, otherwise plotting and animating would've been a nightmare!

My plan is to list the function or app then say what it's used for. I'll start with the apps.
### wheelmakerapp
This is the brains of the operation. This app creates the GUI and provides the instructions as to how the functions interact with one another. This file type is MATLAB specific and provided a nice intuitive way to design the application. Before I created the GUI I had a command line interface, I went against this in the end as with the GUI I had more freedom to edit specific options rather than always having to ask the user questions in a procedural way. It also meant they could start again whenever needed without having to rerun the code.

### TableDisplay
This is how the csv files' tables are displayed, it's again a MATLAB app and I made this choice so that the user didn't have to leave the application to view the file. I thought this was a nice quality of life improvement.

### ModeDisplay
This is the last off the apps and I created this again so the user didn't have to leave the app to view the animations they created. Again a nice quality of life choice.

### b(letters)
This is for all the b__ functions. All these functions are used in conjunction for creating the sparsity matrix, many are needed for all the different blocks involved.

### change_mass_position
Quite intuitive, this function is used the change the positions of the masses, 2d and 3d versions are needed to account for the extra coordinate introduced.

### __Config
All of the functions with config after their name are used for creating the configuration needed. Each one takes different inputs depending on what the user wants the output to be.

### CreatePlot
This is the main function used for plotting. A nice design choice was when you only input one mass to the function it highlights it in red and allows the user to see the connections specific to that mass.

### Add/remove mass
Again quite intuitive. A design choice here was to just move the mass off screen rather than from the array containing the masses as I would've then needed to change the connections on all the other masses.

### Mass and Rim
These are classes for mass and rim objects. I made the choice as treating them as objects so that their properties were easier to keep track of.

### Add connection
This is just used to add more connections.

If you've read through this far you might've noticed a couple extra functions, but these didn't end up being used for the main project.

## Round off
This project took advantage of the MATLAB app designer and used object orientated programming throughout. Without the guidence of CS50 with file I/O and using various technologies making this app wouldn't have been possible. Thank you CS50!
