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

* Extend the FPGA code developed in Lab 3 (Bouncing Ball) and Lab 6 (PONG) to create a 'space invaders' type of game on a 800x600 [Video Graphics Array](https://en.wikipedia.org/wiki/Video_Graphics_Array) (VGA) monitor (See Section 8 on VGA Port and Subsection 8.1 on VGA System Timing of the [Reference Manual]( https://reference.digilentinc.com/_media/reference/programmable-logic/nexys-a7/nexys-a7_rm.pdf)) All controls for the game are located on the Digilent Nexys A7-100T and are the tactile buttons. The middle button starts the game which generates a black screen with a red box on the bottom and an array of 3x5 blue boxes on the top of the screen. The red box can be moved left and right with the buttons to the left and right of the start button. The player is also able to fire green projectiles centered from the red box up the screen by hitting the button forward of the start. The blue boxes at the top will move left and right, and eventually down when they get to one side of the screen. They also randomly fire a projectile down the screen towards the player. If an individual blue box is hit by a player's projectile, they disappear and don't fire anything else towards the player. If a player's red box is hit by an enemy projectile, they disappear and are unable to continue playing without hitting start again.

  ![a7.png](https://github.com/kevinwlu/dsd/blob/master/Nexys-A7/Lab-1/a7.png)

  * The Digilent Nexys A7-100T board has a female [VGA connector](https://en.wikipedia.org/wiki/VGA_connector) that can be connected to a VGA monitor via a VGA cable or a [High-Definition Multimedia Interface](https://en.wikipedia.org/wiki/HDMI) (HDMI) monitor via a [VGA-to-HDMI converter](https://www.ventioncable.com/product/vga-to-hdmi-converter/) with a [micro-B USB](https://en.wikipedia.org/wiki/USB_hardware) power supply.
  * [VGA video](https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml) uses separate wires to transmit the three color component signals and vertical and horizontal synchronization signals.
  * [Horizontal blanking interval](https://en.wikipedia.org/wiki/Horizontal_blanking_interval) consists of front porch, sync pulse, and back porch.
  * [Color mixing](https://en.wikipedia.org/wiki/Color_mixing) of the red and green lights is yellow, the green and blue lights is cyan, and the blue and red lights is magenta. In the absence of light of any color, the result is black. If all three primary colors of light are mixed in equal proportions, the result is neutral (gray or white).

# SUMMARY OF STEPS

# VIDEO

# MODIFICATIONS

# RESPONSIBILITIES/TIMELINE/DIFFICULTIES
