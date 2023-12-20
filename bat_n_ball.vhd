LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        start : IN STD_LOGIC; -- initiates start
        right, left, shoot : IN STD_LOGIC; -- buttons for moving right, left, and shooting
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
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
BEGIN
    red <= ship_on;
    green <= projectile_on OR enemies(0, 0).projectile_on OR enemies(1, 0).projectile_on OR enemies(2, 0).projectile_on OR enemies(0, 1).projectile_on OR enemies(1, 1).projectile_on OR enemies(2, 1).projectile_on OR enemies(0, 2).projectile_on OR enemies(1, 2).projectile_on OR enemies(2, 2).projectile_on OR enemies(0, 3).projectile_on OR enemies(1, 3).projectile_on OR enemies(2, 3).projectile_on OR enemies(0, 4).projectile_on OR enemies(1, 4).projectile_on OR enemies(2, 4).projectile_on;
    blue <= enemies(0, 0).onn OR enemies(1, 0).onn OR enemies(2, 0).onn OR enemies(0, 1).onn OR enemies(1, 1).onn OR enemies(2, 1).onn OR enemies(0, 2).onn OR enemies(1, 2).onn OR enemies(2, 2).onn OR enemies(0, 3).onn OR enemies(1, 3).onn OR enemies(2, 3).onn OR enemies(0, 4).onn OR enemies(1, 4).onn OR enemies(2, 4).onn;
    
    -- process to draw ship and handle shooting
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
            enemies(0, 1).y <= CONV_STD_LOGIC_VECTOR(50, 11);
            enemies(0, 1).x <= CONV_STD_LOGIC_VECTOR(450, 11);
            enemies(0, 1).spawn <= '1';
            enemies(1, 1).y <= CONV_STD_LOGIC_VECTOR(100, 11);
            enemies(1, 1).x <= CONV_STD_LOGIC_VECTOR(450, 11);
            enemies(1, 1).spawn <= '1';
            enemies(2, 1).y <= CONV_STD_LOGIC_VECTOR(150, 11);
            enemies(2, 1).x <= CONV_STD_LOGIC_VECTOR(450, 11);
            enemies(2, 1).spawn <= '1';
            enemies(0, 2).y <= CONV_STD_LOGIC_VECTOR(50, 11);
            enemies(0, 2).x <= CONV_STD_LOGIC_VECTOR(500, 11);
            enemies(0, 2).spawn <= '1';
            enemies(1, 2).y <= CONV_STD_LOGIC_VECTOR(100, 11);
            enemies(1, 2).x <= CONV_STD_LOGIC_VECTOR(500, 11);
            enemies(1, 2).spawn <= '1';
            enemies(2, 2).y <= CONV_STD_LOGIC_VECTOR(150, 11);
            enemies(2, 2).x <= CONV_STD_LOGIC_VECTOR(500, 11);
            enemies(2, 2).spawn <= '1';
            enemies(0, 3).y <= CONV_STD_LOGIC_VECTOR(50, 11);
            enemies(0, 3).x <= CONV_STD_LOGIC_VECTOR(550, 11);
            enemies(0, 3).spawn <= '1';
            enemies(1, 3).y <= CONV_STD_LOGIC_VECTOR(100, 11);
            enemies(1, 3).x <= CONV_STD_LOGIC_VECTOR(550, 11);
            enemies(1, 3).spawn <= '1';
            enemies(2, 3).y <= CONV_STD_LOGIC_VECTOR(150, 11);
            enemies(2, 3).x <= CONV_STD_LOGIC_VECTOR(550, 11);
            enemies(2, 3).spawn <= '1';
            enemies(0, 4).y <= CONV_STD_LOGIC_VECTOR(50, 11);
            enemies(0, 4).x <= CONV_STD_LOGIC_VECTOR(600, 11);
            enemies(0, 4).spawn <= '1';
            enemies(1, 4).y <= CONV_STD_LOGIC_VECTOR(100, 11);
            enemies(1, 4).x <= CONV_STD_LOGIC_VECTOR(600, 11);
            enemies(1, 4).spawn <= '1';
            enemies(2, 4).y <= CONV_STD_LOGIC_VECTOR(150, 11);
            enemies(2, 4).x <= CONV_STD_LOGIC_VECTOR(600, 11);
            enemies(2, 4).spawn <= '1';
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
                    enemies(0, 1).spawn <= '0';
                    enemies(1, 1).spawn <= '0';
                    enemies(2, 1).spawn <= '0';
                    enemies(0, 2).spawn <= '0';
                    enemies(1, 2).spawn <= '0';
                    enemies(2, 2).spawn <= '0';
                    enemies(0, 3).spawn <= '0';
                    enemies(1, 3).spawn <= '0';
                    enemies(2, 3).spawn <= '0';
                    enemies(0, 4).spawn <= '0';
                    enemies(1, 4).spawn <= '0';
                    enemies(2, 4).spawn <= '0';
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
                        enemies(0, 1).spawn <= '0';
                        enemies(1, 1).spawn <= '0';
                        enemies(2, 1).spawn <= '0';
                        enemies(0, 2).spawn <= '0';
                        enemies(1, 2).spawn <= '0';
                        enemies(2, 2).spawn <= '0';
                        enemies(0, 3).spawn <= '0';
                        enemies(1, 3).spawn <= '0';
                        enemies(2, 3).spawn <= '0';
                        enemies(0, 4).spawn <= '0';
                        enemies(1, 4).spawn <= '0';
                        enemies(2, 4).spawn <= '0';
                        enemies(0, 0).projectile_spawn <= '0';
                        enemies(1, 0).projectile_spawn <= '0';
                        enemies(2, 0).projectile_spawn <= '0';
                        enemies(0, 1).projectile_spawn <= '0';
                        enemies(1, 1).projectile_spawn <= '0';
                        enemies(2, 1).projectile_spawn <= '0';
                        enemies(0, 2).projectile_spawn <= '0';
                        enemies(1, 2).projectile_spawn <= '0';
                        enemies(2, 2).projectile_spawn <= '0';
                        enemies(0, 3).projectile_spawn <= '0';
                        enemies(1, 3).projectile_spawn <= '0';
                        enemies(2, 3).projectile_spawn <= '0';
                        enemies(0, 4).projectile_spawn <= '0';
                        enemies(1, 4).projectile_spawn <= '0';
                        enemies(2, 4).projectile_spawn <= '0';
                    ELSIF enemies(2, 4).x >= 800 - ship_w THEN
                        speed <= -speed;
                        enemies(0, 0).y <= enemies(0, 0).y + 40;
                        enemies(0, 0).x <= enemies(0, 0).x - 10;
                        enemies(1, 0).y <= enemies(1, 0).y + 40;
                        enemies(1, 0).x <= enemies(1, 0).x - 10;
                        enemies(2, 0).y <= enemies(2, 0).y + 40;
                        enemies(2, 0).x <= enemies(2, 0).x - 10;
                        enemies(0, 1).y <= enemies(0, 1).y + 40;
                        enemies(0, 1).x <= enemies(0, 1).x - 10;
                        enemies(1, 1).y <= enemies(1, 1).y + 40;
                        enemies(1, 1).x <= enemies(1, 1).x - 10;
                        enemies(2, 1).y <= enemies(2, 1).y + 40;
                        enemies(2, 1).x <= enemies(2, 1).x - 10;
                        enemies(0, 2).y <= enemies(0, 2).y + 40;
                        enemies(0, 2).x <= enemies(0, 2).x - 10;
                        enemies(1, 2).y <= enemies(1, 2).y + 40;
                        enemies(1, 2).x <= enemies(1, 2).x - 10;
                        enemies(2, 2).y <= enemies(2, 2).y + 40;
                        enemies(2, 2).x <= enemies(2, 2).x - 10;
                        enemies(0, 3).y <= enemies(0, 3).y + 40;
                        enemies(0, 3).x <= enemies(0, 3).x - 10;
                        enemies(1, 3).y <= enemies(1, 3).y + 40;
                        enemies(1, 3).x <= enemies(1, 3).x - 10;
                        enemies(2, 3).y <= enemies(2, 3).y + 40;
                        enemies(2, 3).x <= enemies(2, 3).x - 10;
                        enemies(0, 4).y <= enemies(0, 4).y + 40;
                        enemies(0, 4).x <= enemies(0, 4).x - 10;
                        enemies(1, 4).y <= enemies(1, 4).y + 40;
                        enemies(1, 4).x <= enemies(1, 4).x - 10;
                        enemies(2, 4).y <= enemies(2, 4).y + 40;
                        enemies(2, 4).x <= enemies(2, 4).x - 10;
                    ELSIF enemies(0, 0).x <= ship_w THEN
                        speed <= -speed;
                        enemies(0, 0).y <= enemies(0, 0).y + 40;
                        enemies(0, 0).x <= enemies(0, 0).x + 10;
                        enemies(1, 0).y <= enemies(1, 0).y + 40;
                        enemies(1, 0).x <= enemies(1, 0).x + 10;
                        enemies(2, 0).y <= enemies(2, 0).y + 40;
                        enemies(2, 0).x <= enemies(2, 0).x + 10;
                        enemies(0, 1).y <= enemies(0, 1).y + 40;
                        enemies(0, 1).x <= enemies(0, 1).x + 10;
                        enemies(1, 1).y <= enemies(1, 1).y + 40;
                        enemies(1, 1).x <= enemies(1, 1).x + 10;
                        enemies(2, 1).y <= enemies(2, 1).y + 40;
                        enemies(2, 1).x <= enemies(2, 1).x + 10;
                        enemies(0, 2).y <= enemies(0, 2).y + 40;
                        enemies(0, 2).x <= enemies(0, 2).x + 10;
                        enemies(1, 2).y <= enemies(1, 2).y + 40;
                        enemies(1, 2).x <= enemies(1, 2).x + 10;
                        enemies(2, 2).y <= enemies(2, 2).y + 40;
                        enemies(2, 2).x <= enemies(2, 2).x + 10;
                        enemies(0, 3).y <= enemies(0, 3).y + 40;
                        enemies(0, 3).x <= enemies(0, 3).x + 10;
                        enemies(1, 3).y <= enemies(1, 3).y + 40;
                        enemies(1, 3).x <= enemies(1, 3).x + 10;
                        enemies(2, 3).y <= enemies(2, 3).y + 40;
                        enemies(2, 3).x <= enemies(2, 3).x + 10;
                        enemies(0, 4).y <= enemies(0, 4).y + 40;
                        enemies(0, 4).x <= enemies(0, 4).x + 10;
                        enemies(1, 4).y <= enemies(1, 4).y + 40;
                        enemies(1, 4).x <= enemies(1, 4).x + 10;
                        enemies(2, 4).y <= enemies(2, 4).y + 40;
                        enemies(2, 4).x <= enemies(2, 4).x + 10;
                    ELSIF speed > 0 THEN
                        enemies(0, 0).x <= enemies(0, 0).x + speed;
                        enemies(1, 0).x <= enemies(1, 0).x + speed;
                        enemies(2, 0).x <= enemies(2, 0).x + speed;
                        enemies(0, 1).x <= enemies(0, 1).x + speed;
                        enemies(1, 1).x <= enemies(1, 1).x + speed;
                        enemies(2, 1).x <= enemies(2, 1).x + speed;
                        enemies(0, 2).x <= enemies(0, 2).x + speed;
                        enemies(1, 2).x <= enemies(1, 2).x + speed;
                        enemies(2, 2).x <= enemies(2, 2).x + speed;
                        enemies(0, 3).x <= enemies(0, 3).x + speed;
                        enemies(1, 3).x <= enemies(1, 3).x + speed;
                        enemies(2, 3).x <= enemies(2, 3).x + speed;
                        enemies(0, 4).x <= enemies(0, 4).x + speed;
                        enemies(1, 4).x <= enemies(1, 4).x + speed;
                        enemies(2, 4).x <= enemies(2, 4).x + speed;
                    ELSIF speed < 0 THEN
                        enemies(0, 0).x <= enemies(0, 0).x + speed;
                        enemies(1, 0).x <= enemies(1, 0).x + speed;
                        enemies(2, 0).x <= enemies(2, 0).x + speed;
                        enemies(0, 1).x <= enemies(0, 1).x + speed;
                        enemies(1, 1).x <= enemies(1, 1).x + speed;
                        enemies(2, 1).x <= enemies(2, 1).x + speed;
                        enemies(0, 2).x <= enemies(0, 2).x + speed;
                        enemies(1, 2).x <= enemies(1, 2).x + speed;
                        enemies(2, 2).x <= enemies(2, 2).x + speed;
                        enemies(0, 3).x <= enemies(0, 3).x + speed;
                        enemies(1, 3).x <= enemies(1, 3).x + speed;
                        enemies(2, 3).x <= enemies(2, 3).x + speed;
                        enemies(0, 4).x <= enemies(0, 4).x + speed;
                        enemies(1, 4).x <= enemies(1, 4).x + speed;
                        enemies(2, 4).x <= enemies(2, 4).x + speed;
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
END Behavioral;
