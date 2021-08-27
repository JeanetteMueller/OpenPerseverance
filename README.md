# OpenPerseverance
This is a large Project about building your own Perseverance Mars Rover. 
3D printed and remote controlled. 

![CAD of Percy, 19. August 2021](https://github.com/JeanetteMueller/OpenPerseverance/blob/main/images/progress/state_2021-08-19_17.00.37.png)

![Image of Percy, 21. June 2021](https://github.com/JeanetteMueller/OpenPerseverance/blob/main/images/progress/IMG_2082.jpeg)

## Build your own rover
Under the Directory "stl" you find all needed printable parts for your rover. I printed all parts with PLA at 0.1 Layer Height. 
At the Moment you can find the Files:
* Rocker Boogie, the Structure to mount all wheels
* the Differential Arm on top of the Rover
* the large connection block for the outer wall of the rover main body

## Remote Control
I designed everything to controll the rover with a PS4 Gamepad, connected to an iPhone. The iPhone is the brain of everything. It translate the gamepad signals to json code the rover need to move. The Rover sends back her status to the phone like position and power consumtion. the iphone also shoes the camera image of all installed cameras. 

## Rover brain
The Rover runs on a Raspberry Pi Zero with 3 MotorController Boards and a Servo Shield. 
All Programming is done in python (i am new with python so this would be a great opportunity to make this project better)



## Main Body
### UHF Antenna
Needs 6 Carbon Rods: 40mm on front, 44mm on center and 41mm on the back. Two of each with a diameter of 2mm. 