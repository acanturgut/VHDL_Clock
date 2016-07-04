# VHDL_Clock
Koç University - Digital Design Course Final Project - Spring 2015

ELEC 204 DIGITAL SYSTEM DESIGN LABORATORY
LAB PROJECT - DIGITAL CLOCK

DORUK RESMİ - AHMET CAN TURGUT
INSTRUCTOR:  ENGİN ERZİN
DUE DATE:  25.12.2015
Department of Electrical & Electronics
Engineering College of Engineering
Koç University
Fall, 2015

OBJECTIVE:
Purpose of the project is fully understanding and starting empty project, for that purpose LED digital clock was designed, 
implemented and demonstrated on VHDL board. LED digital clock includes several modes such as alarm, set, chronometer, 
and M/S/H, D/Month/Y normal clock mode. 

PROGRESSION:
Before the start project, simple schematic was designed.

Switch 0 and 1 directly related with the changing modes. Mode change set on 2 bit. 
Switch 1 switches hour to year mode. Hour to year switch set on 1bit. And only related with normal mode

SWITCH0-SWITCH1: 00 => NORMAL MODE 
SWITCH0-SWITCH1: 10 => ALARM    MODE
SWITCH0-SWITCH1: 01 => SET           MODE
SWITCH0-SWITCH1: 11 => CHRONOMETER MODE  

After this relation, button relations were designed in order to mod selection.

All buttons defined in 1 bit. Buttons change several states when they pressed once. 

Button relation were given below.

NORMAL MODE

Four Seven Segment Display: Shows only integers and H and Y letters.

Button0: Show current year or hour

ALARM MODE

Four Seven Segment Display: Shows only integers.

LEDS: On-Off

Button0: Change selection minute or hour
Button1: Save changes
Button2: Increment selected item
Button3: Decrement selected item

CHRONOMETER MODE

Four Seven Segment Display: Shows only integers.

Button0: Start counting
Button1: Reset counting
Button2: Pause counting

SET MODE

Four Seven Segment Display: Shows only integers H, Y and two N N for displaying M.

Button0: Change selection minute to year
Button1: Save changes
Button2: Increment selected item
Button3: Decrement selected item

All Led set into 1 into one signal. All Led works together only in alarm mode. Led set into 8 bit.

4 Seven segment displays shows different values according to selected mode.  4 Displays display 4 different value at the same time with clock of the board. 

CLK signal from board was also modified according to our wants and improves counting quality of all modes. 

LOAD THE CODE ON THE BOARD

In this project Spartan 3E XC3S100E CP132 Packages were used. 

