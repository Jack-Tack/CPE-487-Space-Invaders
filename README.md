# CPE-487-Space-Invaders

Your final submission should be a github repository of very similar format to the labs themselves with an opening README document with the expected components as follows:
* A description of the expected behavior of the project, attachments needed (speaker module, VGA connector, etc.), related images/diagrams, etc.
  * The more detailed the better – you all know how much I love a good finite state machine and Boolean logic, so those could be some good ideas if appropriate for your system. If not, some kind of high level block diagram showing how different parts of your program connect together and/or showing how what you have created might fit into a more complete system could be appropriate instead.
* A summary of the steps to get the project to work in Vivado and on the Nexys board
* Images and/or videos of the project in action interspersed throughout to provide context
* “Modifications”
  * If building on an existing lab or expansive starter code of some kind, describe your “modifications” – the changes made to that starter code to improve the code, create entirely new functionalities, etc. Please share any starter code used as well.
  * If you truly created your code/project from scratch, describe that in brief here.
* Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc.
=======================================================================================================================================================================================
# DESCRIPTION OF BEHAVIOR

* Upper Button is shoot
* Middle Button is start
* Left Button is left
* Right Button is right

* Extend the FPGA code developed in Lab 3 (Bouncing Ball) and Lab 6 (PONG) to create a 'space invaders' type of game on a 800x600 [Video Graphics Array](https://en.wikipedia.org/wiki/Video_Graphics_Array) (VGA) monitor (See Section 8 on VGA Port and Subsection 8.1 on VGA System Timing of the [Reference Manual]( https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf)) All controls for the game are located on the Digilent Nexys A7-100T and are the tactile buttons. The middle button starts the game which generates a black screen with a red box on the bottom and an array of 3x5 blue boxes on the top of the screen. The blue boxes at the top will move left and right, 

  * The Digilent Nexys A7-100T board has a female [VGA connector](https://en.wikipedia.org/wiki/VGA_connector) that can be connected to a VGA monitor via a VGA cable or a [High-Definition Multimedia Interface](https://en.wikipedia.org/wiki/HDMI) (HDMI) monitor via a [VGA-to-HDMI converter](https://www.ventioncable.com/product/vga-to-hdmi-converter/) with a [micro-B USB](https://en.wikipedia.org/wiki/USB_hardware) power supply.
  * [VGA video](https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml) uses separate wires to transmit the three color component signals and vertical and horizontal synchronization signals.
  * [Horizontal blanking interval](https://en.wikipedia.org/wiki/Horizontal_blanking_interval) consists of front porch, sync pulse, and back porch.
  * [Color mixing](https://en.wikipedia.org/wiki/Color_mixing) of the red and green lights is yellow, the green and blue lights is cyan, and the blue and red lights is magenta. In the absence of light of any color, the result is black. If all three primary colors of light are mixed in equal proportions, the result is neutral (gray or white).

# SUMMARY OF STEPS

* First, we decided to take the base code of the pong lab assignment and repurpose it. To achieve this, we deleted all of the code in bat_n_ball.vhd and edited the code in pong.vhd that was associated. We then added in the constraint file the ability to press the upper button to shoot, the left button to move left, and the right button to move right. We didn’t want to use the controller that was used in the pong lab as we did not wish to take it home with us to continue working.

* After this initial copying and cleaning, we created the base signals, arrays, and ports that we would eventually need to complete the project. For this we edited both the pong.vhd and the bat_n_ball.vhd files.

* Next, we assigned colors to the player, the projectiles of both the player and the enemies, and the enemies themselves, while making the background black.

* After the setup, we added in a process that allowed us to create a square player and move it using the buttons on the board. Within this process were functions for movement, and collision (which was based on what was done for the bat in the pong lab).

* We then created a process for the player projectile, where it spawned when the appropriate button was pressed and despawned when hitting an enemy. Furthermore, it would move constantly once spawned and would despawn if the enemy reached the goal or if it reached the boundary.

* The final process that we created was the one for the enemy. The enemies spawn spaced out when the start button is pressed, and each have their own individual collision within the environment and with the player projectile. If one is ever hit, only that particular enemy is deleted, and each enemy can fire at the player. When the enemies collectively hit either side wall, they move down slightly and begin to move in the opposite direction. If the player is ever hit by the enemy projectile, all of the enemies despawn as the game is considered over. Additionally, the enemy projectile has its own logic that is controlled within the enemy process.

# VIDEO

# MODIFICATIONS

# RESPONSIBILITIES/TIMELINE/DIFFICULTIES
