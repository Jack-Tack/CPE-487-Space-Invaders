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

### 1. Create a new RTL project _pong_ in Vivado Quick Start

* Create six new source files of file type VHDL called **_clk_wiz_0_**, **_clk_wiz_0_clk_wiz_**, **_vga_sync_**, **_bat_n_ball_**, **_adc_if_**, and **_pong_**

* Create a new constraint file of file type XDC called **_pong_**

* Choose Nexys A7-100T board for the project

* Click 'Finish'

* Click design sources and copy the VHDL code from clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync.vhd, bat_n_ball.vhd, adc_if.vhd, pong.vhd

* Click constraints and copy the code from pong.xdc

### 2. Run synthesis

### 3. Run implementation and open implemented design

### 4. Generate bitstream, open hardware manager, and program device

* Click 'Generate Bitstream'

* Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'

* Click 'Program Device' then xc7a100t_0 to download pong.bit to the Nexys A7-100T board

* Push BTNC to start the game and try to shoot all the blue squares before they reach the bottom.



# VIDEO

https://github.com/Jack-Tack/CPE-487-Space-Invaders/assets/73898301/3f761f39-31ce-4b55-942a-ca854ea8fba6
   
# MODIFICATIONS

* First, we decided to take the base code of the pong lab assignment and repurpose it. To achieve this, we deleted all of the code in bat_n_ball.vhd and edited the code in pong.vhd that was associated. We then added in the constraint file the ability to press the upper button to shoot, the left button to move left, and the right button to move right. We didn’t want to use the controller that was used in the pong lab as we did not wish to take it home with us to continue working.
  * Within pong.xdc, we added these three lines, which allowed us to use the upper, left, and right buttons:
``` 
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { BTNU }]; #IO_L4N_T0_D05_14 Sch=btnu
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { BTNL }]; #IO_L12P_T1_MRCC_14 Sch=btnl
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { BTNR }]; #IO_L10N_T1_D15_14 Sch=btnr
```
  * We then added these lines in pong.vhd:
```
BTNR : IN STD_LOGIC;
BTNL : IN STD_LOGIC;
BTNU : IN STD_LOGIC;
```

* After this initial copying and cleaning, we created the base signals, arrays, and ports that we would eventually need to complete the project. For this we edited both the pong.vhd and the bat_n_ball.vhd files.
  * In pong.vhd, we added this to the bat_n_ball initialization:
 ```
  right, left, shoot : IN STD_LOGIC;
 ```
  * Then we added this in the port mapping for bat_n_ball:
 ```
 right => BTNR,
left => BTNL,
shoot => BTNU,
```
  * For the initial ports, we added these lines of code, which allowed us to use the data from pong.vhd and the other files:
```
v_sync : IN STD_LOGIC;
pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
start : IN STD_LOGIC; -- initiates start
right, left, shoot : IN STD_LOGIC; -- buttons for moving right, left, and shooting
red : OUT STD_LOGIC;
green : OUT STD_LOGIC;
blue : OUT STD_LOGIC;
```
  * For the signals and arrays, we added these lines underneath the architecture for bat_n_ball, which would constantly be used later:
    ```
    CONSTANT ship_w : INTEGER := 16; -- ship width in pixels
    CONSTANT ship_h : INTEGER := 16; -- ship height in pixels
    SIGNAL ship_spawn : STD_LOGIC := '1';
    SIGNAL ship_on : STD_LOGIC := '0'; -- indicates whether ship is at current pixel position
    -- enemy variables
    TYPE EnemyRecord IS RECORD
        x : STD_LOGIC_VECTOR(10 DOWNTO 0);
        y : STD_LOGIC_VECTOR(10 DOWNTO 0);
        projectile_spawn : STD_LOGIC;
        projectile_on : STD_LOGIC;
        projectile_x : STD_LOGIC_VECTOR(10 DOWNTO 0);
        projectile_y : STD_LOGIC_VECTOR(10 DOWNTO 0);
        spawn : STD_LOGIC;
        onn : STD_LOGIC;
    END RECORD;
    TYPE EnemyArray IS ARRAY (0 TO 2, 0 TO 4) OF EnemyRecord;
    CONSTANT EnemyRecordInit : EnemyRecord := (x => (OTHERS => '0'), y => (OTHERS => '0'), projectile_spawn => '0', projectile_on => '0', projectile_x => (OTHERS => '0'), projectile_y => (OTHERS => '0'), spawn => '0', onn => '0');
    SIGNAL enemies : EnemyArray := (
    (EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit), 
    (EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit),
    (EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit, EnemyRecordInit));
    SIGNAL speed : INTEGER := 1;
    -- ship position
    SIGNAL ship_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(400, 11);
    CONSTANT ship_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(550, 11);
    -- projectile variables
    SIGNAL projectile_spawn : STD_LOGIC := '0';
    SIGNAL projectile_on : STD_LOGIC := '0';
    SIGNAL projectile_w : INTEGER := 2;
    SIGNAL projectile_h : INTEGER := 6;
    SIGNAL projectile_x : STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0');
    SIGNAL projectile_y : STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0');
    ```

* Next, we assigned colors to the player, the projectiles of both the player and the enemies, and the enemies themselves, while making the background black.
 For this, we added in these lines, making use of the red, blue, and green from pong.vhd:
   ```
    red <= ship_on;
    green <= projectile_on OR enemies(0, 0).projectile_on OR enemies(1, 0).projectile_on OR enemies(2, 0).projectile_on OR enemies(0, 1).projectile_on OR enemies(1, 1).projectile_on OR enemies(2, 1).projectile_on OR enemies(0, 2).projectile_on OR enemies(1, 2).projectile_on OR enemies(2, 2).projectile_on OR enemies(0, 3).projectile_on OR enemies(1, 3).projectile_on OR enemies(2, 3).projectile_on OR enemies(0, 4).projectile_on OR enemies(1, 4).projectile_on OR enemies(2, 4).projectile_on;
    blue <= enemies(0, 0).onn OR enemies(1, 0).onn OR enemies(2, 0).onn OR enemies(0, 1).onn OR enemies(1, 1).onn OR enemies(2, 1).onn OR enemies(0, 2).onn OR enemies(1, 2).onn OR enemies(2, 2).onn OR enemies(0, 3).onn OR enemies(1, 3).onn OR enemies(2, 3).onn OR enemies(0, 4).onn OR enemies(1, 4).onn OR enemies(2, 4).onn;
   ```

* After the setup, we added in a process that allowed us to create a square player and move it using the buttons on the board. Within this process were functions for movement, and collision (which was based on what was done for the bat in the pong lab).
  * This is the process that we created, which was definitely the simplest in terms of complexity and didn’t require much thinking outside the box:
    ```
    shipdraw : PROCESS (v_sync, right, left, start, enemies, pixel_col, pixel_row, ship_spawn, projectile_w, projectile_h, ship_x) IS
    BEGIN     
        -- Movement logic with counter to control speed
        IF rising_edge(v_sync) THEN
            IF right = '1' AND left = '1' THEN
                ship_x <= ship_x;
            ELSIF right = '1' AND ship_x < 800 - ship_w THEN
                ship_x <= ship_x + 2;
            ELSIF left = '1' AND ship_x > ship_w THEN
                ship_x <= ship_x - 2;
            END IF;
        END IF;

        -- Collision detection
        IF ((pixel_col >= ship_x - ship_w) OR (ship_x <= ship_w)) AND
            pixel_col <= ship_x + ship_w AND
            pixel_row >= ship_y - ship_h AND
            pixel_row <= ship_y + ship_h THEN
            ship_on <= ship_spawn;
        ELSE
            ship_on <= '0';
        END IF;
    END PROCESS;
    ```

* We then created a process for the player projectile, where it spawned when the appropriate button was pressed and despawned when hitting an enemy. Furthermore, it would move constantly once spawned and would despawn if the enemy reached the goal or if it reached the boundary.
  * This was much more challenging as we had to account for the projectile despawning and hitting the enemies, however it wasn’t so challenging that it took too long to complete:
  ```
    -- process to handle projectile movement
    projectile_movement : PROCESS (v_sync, shoot, enemies, pixel_col, pixel_row, ship_spawn, projectile_spawn, ship_x, projectile_x, projectile_y, projectile_w, projectile_h) IS
    BEGIN
        -- Spawning
        IF shoot = '1' AND ship_spawn = '1' AND projectile_spawn = '0' THEN
            projectile_x <= ship_x;
            projectile_y <= ship_y - ship_h;
            projectile_spawn <= '1';
        END IF;
        
        -- Collision
        IF ((pixel_col >= projectile_x - projectile_w) OR (projectile_x <= projectile_w)) AND
            pixel_col <= projectile_x + projectile_w AND
            pixel_row >= projectile_y - projectile_h AND
            pixel_row <= projectile_y + projectile_h THEN
            projectile_on <= projectile_spawn;
        ELSE
            projectile_on <= '0';
        END IF;
        
        -- Collision with enemy
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF enemies(i, j).spawn = '1' THEN
                    IF (projectile_x + (projectile_w / 2)) >= (enemies(i, j).x - ship_w) AND
                        (projectile_x - (projectile_w / 2)) <= (enemies(i, j).x + ship_w) AND
                        (projectile_y + (projectile_h / 2)) >= (enemies(i, j).y - ship_h) AND
                        (projectile_y - (projectile_h / 2)) <= (enemies(i, j).y + ship_h) THEN
                        projectile_spawn <= '0';
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
        
        -- Despawn when enemy reaches the bottom
        IF enemies(2, 4).y >= 530 THEN
            projectile_spawn <= '0';
        END IF;
        
        -- Collision for enemy projectile and player
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF (enemies(i, j).projectile_x + (projectile_w / 2)) >= (ship_x - ship_w) AND
                    (enemies(i, j).projectile_x - (projectile_w / 2)) <= (ship_x + ship_w) AND
                    (enemies(i, j).projectile_y + (projectile_h / 2)) >= (ship_y - ship_h) AND
                    (enemies(i, j).projectile_y - (projectile_h / 2)) <= (ship_y + ship_h) THEN
                    projectile_spawn <= '0';
                END IF;
            END LOOP;
        END LOOP;
        
        IF rising_edge(v_sync) THEN
            IF projectile_spawn = '1' THEN
                -- Move the projectile upward
                projectile_y <= projectile_y - 10;

                -- Check if projectile is out of bounds
                IF projectile_y <= projectile_h THEN
                    projectile_spawn <= '0';  -- Reset projectile when it reaches the top
                END IF;
            END IF;
        END IF;
    END PROCESS;
   ```

* The final process that we created was the one for the enemy. The enemies spawn spaced out when the start button is pressed, and each have their own individual collision within the environment and with the player projectile. If one is ever hit, only that particular enemy is deleted, and each enemy can fire at the player. When the enemies collectively hit either side wall, they move down slightly and begin to move in the opposite direction. If the player is ever hit by the enemy projectile, all of the enemies despawn as the game is considered over. Additionally, the enemy projectile has its own logic that is controlled within the enemy process.
  * This was extremely hard as we had very little experience working with arrays in VHDL, but we managed to pull through and figure out how to make each enemy individual while also moving as a collective:
```
      -- process to handle enemies

       enemy : PROCESS (v_sync, start, enemies, pixel_col, pixel_row, projectile_x, projectile_y, projectile_w, projectile_h, ship_x) IS
        VARIABLE shoot_counter : INTEGER := 0;
       BEGIN
        IF start = '1' THEN -- test for new start
            enemies(0, 0).y <= CONV_STD_LOGIC_VECTOR(50, 11);
            enemies(0, 0).x <= CONV_STD_LOGIC_VECTOR(400, 11);
            enemies(0, 0).spawn <= '1';
            enemies(1, 0).y <= CONV_STD_LOGIC_VECTOR(100, 11);
            enemies(1, 0).x <= CONV_STD_LOGIC_VECTOR(400, 11);
            enemies(1, 0).spawn <= '1';
            enemies(2, 0).y <= CONV_STD_LOGIC_VECTOR(150, 11);
            enemies(2, 0).x <= CONV_STD_LOGIC_VECTOR(400, 11);
            enemies(2, 0).spawn <= '1';
            ...
          END IF;

        -- Collision with projectile
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF enemies(i, j).spawn = '1' THEN
                    IF (projectile_x + (projectile_w / 2)) >= (enemies(i, j).x - ship_w) AND
                        (projectile_x - (projectile_w / 2)) <= (enemies(i, j).x + ship_w) AND
                        (projectile_y + (projectile_h / 2)) >= (enemies(i, j).y - ship_h) AND
                        (projectile_y - (projectile_h / 2)) <= (enemies(i, j).y + ship_h) THEN
                        enemies(i, j).spawn <= '0';
                    END IF;
                END IF;
            END LOOP;
        END LOOP;
        
        -- Collision for enemy projectile and player
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF (enemies(i, j).projectile_x + (projectile_w / 2)) >= (ship_x - ship_w) AND
                    (enemies(i, j).projectile_x - (projectile_w / 2)) <= (ship_x + ship_w) AND
                    (enemies(i, j).projectile_y + (projectile_h / 2)) >= (ship_y - ship_h) AND
                    (enemies(i, j).projectile_y - (projectile_h / 2)) <= (ship_y + ship_h) THEN
                    enemies(0, 0).spawn <= '0';
                    enemies(1, 0).spawn <= '0';
                    enemies(2, 0).spawn <= '0';
                    ...
                END IF;
            END LOOP;
        END LOOP;
        
        -- Collision
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF ((pixel_col >= enemies(i, j).x - ship_w) OR (enemies(i, j).x <= ship_w)) AND
                    pixel_col <= enemies(i, j).x + ship_w AND
                    pixel_row >= enemies(i, j).y - ship_h AND
                    pixel_row <= enemies(i, j).y + ship_h THEN
                    enemies(i, j).onn <= enemies(i, j).spawn;
                ELSE 
                    enemies(i, j).onn <= '0';
                END IF;
            END LOOP;
        END LOOP;
        
        -- Collision for enemy projectile
        FOR i IN 0 TO 2 LOOP
            FOR j IN 0 TO 4 LOOP
                IF ((pixel_col >= enemies(i, j).projectile_x - projectile_w) OR (enemies(i, j).projectile_x <= projectile_w)) AND
                    pixel_col <= enemies(i, j).projectile_x + projectile_w AND
                    pixel_row >= enemies(i, j).projectile_y - projectile_h AND
                    pixel_row <= enemies(i, j).projectile_y + projectile_h THEN
                    enemies(i, j).projectile_on <= enemies(i, j).projectile_spawn;
                ELSE
                    enemies(i, j).projectile_on <= '0';
                END IF;
            END LOOP;
        END LOOP;
        
        -- Movement
        IF rising_edge(v_sync) THEN
            FOR i IN 0 TO 2 LOOP
                FOR j IN 0 TO 4 LOOP
                    IF enemies(2, 4).y >= 530 THEN
                        enemies(0, 0).spawn <= '0';
                        enemies(1, 0).spawn <= '0';
                        enemies(2, 0).spawn <= '0';
                        ...
                    ELSIF enemies(2, 4).x >= 800 - ship_w THEN
                        speed <= -speed;
                        enemies(0, 0).y <= enemies(0, 0).y + 40;
                        enemies(0, 0).x <= enemies(0, 0).x - 10;
                        enemies(1, 0).y <= enemies(1, 0).y + 40;
                        enemies(1, 0).x <= enemies(1, 0).x - 10;
                        enemies(2, 0).y <= enemies(2, 0).y + 40;
                        enemies(2, 0).x <= enemies(2, 0).x - 10;
                        ...
                    ELSIF enemies(0, 0).x <= ship_w THEN
                        speed <= -speed;
                        enemies(0, 0).y <= enemies(0, 0).y + 40;
                        enemies(0, 0).x <= enemies(0, 0).x + 10;
                        enemies(1, 0).y <= enemies(1, 0).y + 40;
                        enemies(1, 0).x <= enemies(1, 0).x + 10;
                        enemies(2, 0).y <= enemies(2, 0).y + 40;
                        enemies(2, 0).x <= enemies(2, 0).x + 10;
                        ...
                    ELSIF speed > 0 THEN
                        enemies(0, 0).x <= enemies(0, 0).x + speed;
                        enemies(1, 0).x <= enemies(1, 0).x + speed;
                        enemies(2, 0).x <= enemies(2, 0).x + speed;
                        ...
                    ELSIF speed < 0 THEN
                        enemies(0, 0).x <= enemies(0, 0).x + speed;
                        enemies(1, 0).x <= enemies(1, 0).x + speed;
                        enemies(2, 0).x <= enemies(2, 0).x + speed;
                        ...
                    END IF;
      
                    -- Shooting behavior every 1000th v_sync
                    shoot_counter := shoot_counter + 1;
                    IF enemies(i, j).spawn = '1' AND shoot_counter >= 1000 THEN
                        enemies(i, j).projectile_x <= enemies(i, j).x;
                        enemies(i, j).projectile_y <= enemies(i, j).y + ship_h;
                        enemies(i, j).projectile_spawn <= '1';

                        -- Reset the counter
                        shoot_counter := 0;
                    END IF;
                
                    -- Enemy projectile movement
                    IF enemies(i, j).projectile_spawn = '1' THEN
                        enemies(i, j).projectile_y <= enemies(i, j).projectile_y + 10;
                    
                        IF enemies(i, j).projectile_y >= 600 - projectile_h THEN
                            enemies(i, j).projectile_spawn <= '0';
                        END IF;
                    END IF;
                END LOOP;
            END LOOP;
        END IF;
    END PROCESS;
 ```

# RESPONSIBILITIES/TIMELINE/DIFFICULTIES

## Responsibilities
* Aidan Rudd worked with the enemy logic and the various processes associated with it. Also worked on converting lab 6 to work with the game 
* John Goceljak and Matt Bairstow helped with projectile logic and death conditions, as well as planning for how to implement the enemies. 


## Timeline
* Week 1: Converted Lab 6 code to create a player block and spawn a projectile. Recolored the background, projectile, and player
* Week 2: Fixed projectile drawing code, added signals for enemies
* Week 3: Added logic for single enemy movement and enemy death
* Week 4: Made enemies into an array and added looping logic to check for enemy deaths. Added enemy shooting

## Problems
* Faulty Cable: while working on the project our cable broke and we needed to go in person to get a new one
* Projectile not spawning: Initially the projectile wasn’t spawning in at all, this was fixed by reworking the drawing logic.
* Hardcoding each enemy proved to be problematic, so we had to learn how VHDL arrays and loops worked in order to make an array of enemies. Since it was feared some of the functions would be too slow, we manually addressed all the enemies in the array in the functions rather than leaving it to loops most of the time.
* When killing an enemy, the enemy shooting changes. Not exactly a problem but we don’t know why this behavior exists
* 


