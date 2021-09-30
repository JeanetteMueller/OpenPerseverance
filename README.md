# OpenPerseverance
This is a large Project about building your own Perseverance Mars Rover. 
3D printed and remote controlled. 

![CAD of Percy, 22. September 2021](https://github.com/JeanetteMueller/OpenPerseverance/blob/main/images/progress/state_2021-09-22-13.20.24.png)

![Image of Percy with her Maker, 8. September 2021](https://github.com/JeanetteMueller/OpenPerseverance/blob/main/images/progress/2021-09-08_Perseverance_006.jpg)

![Image of Percy, 8. September 2021](https://github.com/JeanetteMueller/OpenPerseverance/blob/main/images/progress/2021-09-08_Perseverance_016.jpg)

## Build your own rover
Under the Directory "stl" you find all needed printable parts for your rover. I will update and add new files while development.

### MainBody
* BridgeBase 
* DifferentialBodyMount
* DifferentialBlocker
* FrontBodyCamera
* HighGainAntenna
* LowGainAntenna
* SampleCollector
* ShellConnector
* ShellToProfileConnector
* SkyCraneConnector
* Sundial
* TopBox
* UHF

### RockerBogie
* WheelHolderCenter
* WheelHolder
* Tire
* Wheel Rim
* RodConnectorFront
* ServoConnector
* DifferentialMount
* RodConnectorBack
* DifferentialArm
* DifferentialArmHead
* CenterRodMount
* CenterRodMountCover
* BoogieCenterInternal
* BearingCenter
* BoogieCenterExternal
* BalanceArmConnector
* BalanceArmCenter
* BalanceArm

### Tower
(to be added)

### HeatExchanger
* Wall
* Holder
* Heatpipes
	
### Arm
(to be added)

## Remote Control
I designed everything to controll the rover with a PS4 Gamepad, connected to an iPhone. The iPhone is the brain of everything. It translate the gamepad signals to json code the rover need to move. The iPhone also shows the camera images of all installed cameras. 

## Rover brain
The Rover main Functions run on a Raspberry Pi 3b with 3 MotorController Boards and two Servo Shield. 
Inside of the Camera Tower you need a Raspberry Pi Zero W to control the Head mounted Camera and the Lights around the eyelid. 
All Programming is done in python (i am new with python so this would be a great opportunity to make this project better)

## Instructions

### Main Body
* 20x20 Alloy profile B-Type Nut 6
	4x 30cm
	5x 40cm
* 8x Angle 20 x 40 Nut 6 Bosch grid with fastening
* 50x Hammer Nut 6 M4
* Ball Bearings
	4x 35 x 47 x 7 mm   
	8x 8 x 22 x 7mm
* Alloy Rod 25 mm x 2 mm (inner Diameter 21mm)
	* 4x 150mm
	* 2x 100mm
	* 2x 120mm
* 4x JX Servo 1181MG
* 2x Servo MG90s
* Raspberry Pi 3b (or newer)
* Raspberry Pi Zero W
* Camera Longruner for Raspberry Pi
* ESP32 with Cam


### UHF Antenna
Needs 6 Carbon Rods: 40mm on front, 44mm on center and 41mm on the back. Two of each with a diameter of 2mm. 