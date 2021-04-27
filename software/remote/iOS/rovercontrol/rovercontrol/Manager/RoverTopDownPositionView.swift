//
//  RoverTopDownPositionView.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 19.04.21.
//

import UIKit

class RoverTopDownPositionView: UIView {
    
    var rover: Rover
    
    var body: UIView
    var wheelLeftFront: UIView
    var wheelLeftCenter: UIView
    var wheelLeftBack: UIView
    
    var wheelRightFront: UIView
    var wheelRightCenter: UIView
    var wheelRightBack: UIView
    
    var infoLeftFront: UILabel
    var infoLeftCenter: UILabel
    var infoLeftBack: UILabel
    
    var infoRightFront: UILabel
    var infoRightCenter: UILabel
    var infoRightBack: UILabel
    
    init(withRover r:Rover) {
        self.rover = r
        let wheelWidth: CGFloat = 8.8
        let wheelHeight: CGFloat = 12
        
        let infoLabelWidth: CGFloat = 74 //45
        let infoLabelHeight: CGFloat = wheelHeight * 2
        let infoLabelDistance: CGFloat = 4
        
        body = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 56))
        
        
        wheelLeftFront = UIView(frame: CGRect(x: 0, y: 0,   width: wheelWidth, height: wheelHeight))
        wheelLeftCenter = UIView(frame: CGRect(x: 0, y: 0,  width: wheelWidth, height: wheelHeight))
        wheelLeftBack = UIView(frame: CGRect(x: 0, y: 0,    width: wheelWidth, height: wheelHeight))
        wheelRightFront = UIView(frame: CGRect(x: 0, y: 0,  width: wheelWidth, height: wheelHeight))
        wheelRightCenter = UIView(frame: CGRect(x: 0, y: 0, width: wheelWidth, height: wheelHeight))
        wheelRightBack = UIView(frame: CGRect(x: 0, y: 0,   width: wheelWidth, height: wheelHeight))
        
        infoLeftFront = UILabel(frame: CGRect(x: 0, y: 0,   width: infoLabelWidth, height: infoLabelHeight))
        infoRightFront = UILabel(frame: CGRect(x: 0, y: 0,  width: infoLabelWidth, height: infoLabelHeight))
        infoLeftCenter = UILabel(frame: CGRect(x: 0, y: 0,  width: infoLabelWidth, height: infoLabelHeight * 0.7))
        infoRightCenter = UILabel(frame: CGRect(x: 0, y: 0, width: infoLabelWidth, height: infoLabelHeight * 0.7))
        infoLeftBack = UILabel(frame: CGRect(x: 0, y: 0,    width: infoLabelWidth, height: infoLabelHeight))
        infoRightBack = UILabel(frame: CGRect(x: 0, y: 0,   width: infoLabelWidth, height: infoLabelHeight))
        
        super.init(frame: CGRect(x: 0, y: 0, width: 190, height: 110))
        
        self.clipsToBounds = false
        self.backgroundColor = UIColor.clear
        
        body.backgroundColor = UIColor.white //.withAlphaComponent(0.5)
        
        for wheel in [wheelLeftFront, wheelLeftCenter, wheelLeftBack, wheelRightFront, wheelRightCenter, wheelRightBack] {
            applyWheelDesign(wheel)
        }
        
        for label in [infoLeftFront, infoLeftCenter, infoLeftBack, infoRightFront, infoRightCenter, infoRightBack] {
            applyInfoDesign(label)
        }
        
        
        self.addSubview(body)
        body.center = self.center
        
        
        
        
        self.addSubview(wheelLeftFront)
        wheelLeftFront.center = CGPoint(x: self.center.x-24 - wheelWidth/2, y: self.center.y - 27)
        wheelLeftFront.backgroundColor = .red
        
        self.addSubview(infoLeftFront)
        infoLeftFront.center = CGPoint(x: wheelLeftFront.center.x - infoLabelWidth/2 - wheelWidth/2 - infoLabelDistance - 2, y: wheelLeftFront.center.y)
        
        
        self.addSubview(wheelLeftCenter)
        wheelLeftCenter.center = CGPoint(x: self.center.x-26 - wheelWidth/2, y: self.center.y )
        
        self.addSubview(infoLeftCenter)
        infoLeftCenter.center = CGPoint(x: wheelLeftCenter.center.x - infoLabelWidth/2 - wheelWidth/2 - infoLabelDistance, y: wheelLeftCenter.center.y)
        
        
        self.addSubview(wheelLeftBack)
        wheelLeftBack.center = CGPoint(x: self.center.x-24 - wheelWidth/2, y: self.center.y + 27)
        
        self.addSubview(infoLeftBack)
        infoLeftBack.center = CGPoint(x: wheelLeftBack.center.x - infoLabelWidth/2 - wheelWidth/2 - infoLabelDistance - 2, y: wheelLeftBack.center.y)
        

        
        
        
        self.addSubview(wheelRightFront)
        wheelRightFront.center = CGPoint(x: self.center.x+24 + wheelWidth/2, y: self.center.y - 27)
        wheelRightFront.backgroundColor = .green
        
        self.addSubview(infoRightFront)
        infoRightFront.center = CGPoint(x: wheelRightFront.center.x + infoLabelWidth/2 + wheelWidth/2 + infoLabelDistance + 2, y: wheelRightFront.center.y)
        
        
        self.addSubview(wheelRightCenter)
        wheelRightCenter.center = CGPoint(x: self.center.x+26 + wheelWidth/2, y: self.center.y )
        
        self.addSubview(infoRightCenter)
        infoRightCenter.center = CGPoint(x: wheelRightCenter.center.x + infoLabelWidth/2 + wheelWidth/2 + infoLabelDistance, y: wheelRightCenter.center.y)
        
        
        self.addSubview(wheelRightBack)
        wheelRightBack.center = CGPoint(x: self.center.x+24 + wheelWidth/2, y: self.center.y + 27)
        
        self.addSubview(infoRightBack)
        infoRightBack.center = CGPoint(x: wheelRightBack.center.x + infoLabelWidth/2 + wheelWidth/2 + infoLabelDistance + 2, y: wheelRightBack.center.y)
        
        
        
        
        
        
        
        
        self.updateMovableParts()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func applyWheelDesign(_ w:UIView) {
        w.backgroundColor = .darkGray
    }
    private func applyInfoDesign(_ l: UILabel) {
        l.layer.borderWidth = 0.5
        l.layer.borderColor = UIColor.darkGray.cgColor
        l.font = UIFont.systemFont(ofSize: 9)
        l.textAlignment = .left
        l.numberOfLines = 0
    }
    
    
    var currentWheelRotation: Rover.WheelRotation = Rover.WheelRotation(fl: 80, fr: 80, bl: 80, br: 80)
    func updateWheelRotation(_ v: Rover.WheelRotation) {
        self.currentWheelRotation = v
        self.updateMovableParts()
    }
    var currentMotorInformation: Rover.MotorInformation = Rover.MotorInformation(left: 0, leftCenter: 0, right: 0, rightCenter: 0)
    func updateMotorInformation(_ v: Rover.MotorInformation) {
        self.currentMotorInformation = v
        self.updateMovableParts()
    }
    var currentArmInformation: Rover.ArmInformation = Rover.ArmInformation(joint1: 0, joint2: 0, joint3: 0, joint4: 0)
    func updateArmInformation(_ v: Rover.ArmInformation) {
        self.currentArmInformation = v
        self.updateMovableParts()
    }
    
    var currentLightInformation: Rover.LightInformation = Rover.LightInformation(light1:0, light2:0, light3:0, light4:0)
    func updateLightInformation(_ v: Rover.LightInformation) {
        self.currentLightInformation = v
        self.updateMovableParts()
    }
    
    var currentTowerInformation: Rover.TowerInformation = Rover.TowerInformation(position:0, rotation:0, tilt:0)
    func updateTowerInformation(_ v: Rover.TowerInformation) {
        self.currentTowerInformation = v
        self.updateMovableParts()
    }
    
    
    
    func updateMovableParts() {
        let wheel = self.currentWheelRotation
        let motor = self.currentMotorInformation
        
        
        self.wheelLeftFront.transform = CGAffineTransform(rotationAngle: CGFloat((wheel.fl - 80) * Float(Double.pi) / 180))
        self.wheelRightFront.transform = CGAffineTransform(rotationAngle: CGFloat((wheel.fr - 80) * Float(Double.pi) / 180))
        
        self.wheelLeftBack.transform = CGAffineTransform(rotationAngle: CGFloat((wheel.bl - 80) * Float(Double.pi) / 180))
        self.wheelRightBack.transform = CGAffineTransform(rotationAngle: CGFloat((wheel.br - 80) * Float(Double.pi) / 180))
        
        
        
        self.infoLeftFront.text =   String(format: " Motor %.1f %%\n Rotation %.2f°", motor.left, wheel.fl - 80)
        self.infoLeftCenter.text =  String(format: " Motor %.1f %%", motor.leftCenter)
        self.infoLeftBack.text =    String(format: " Motor %.1f %%\n Rotation %.2f°", motor.left, wheel.bl - 80)
        
        self.infoRightFront.text =  String(format: " Motor %.1f %%\n Rotation %.2f°", motor.right, wheel.fr - 80)
        self.infoRightCenter.text = String(format: " Motor %.1f %%", motor.rightCenter)
        self.infoRightBack.text =   String(format: " Motor %.1f %%\n Rotation %.2f°", motor.right, wheel.br - 80)
        
        
        if let l = self.steeringLeftPoly {
            l.removeFromSuperlayer()
        }
        if let l = self.steeringRightPoly {
            l.removeFromSuperlayer()
        }
        
        if wheel.fl != 80 || wheel.fr != 80 {
            
            let leftShape = CAShapeLayer()
            self.layer.addSublayer(leftShape)
            self.steeringLeftPoly = leftShape
            
            leftShape.opacity = 0.5
            leftShape.lineWidth = 0.5
            leftShape.lineJoin = CAShapeLayerLineJoin.miter
            leftShape.strokeColor = UIColor.red.cgColor
            leftShape.fillColor = UIColor.red.withAlphaComponent(0.5).cgColor
            
            let rightShape = CAShapeLayer()
            self.layer.addSublayer(rightShape)
            self.steeringRightPoly = rightShape
            
            rightShape.opacity = 0.5
            rightShape.lineWidth = 0.5
            rightShape.lineJoin = CAShapeLayerLineJoin.miter
            rightShape.strokeColor = UIColor.green.cgColor
            rightShape.fillColor = UIColor.green.withAlphaComponent(0.5).cgColor
            
            if wheel.fl - 80 < 0 {
                // nach links
                
                let leftPath = UIBezierPath()
                leftPath.move(to: CGPoint(x: wheelLeftFront.center.x, y: wheelLeftFront.center.y + CGFloat(self.rover.radStand/2)))
                leftPath.addLine(to: CGPoint(x: wheelLeftFront.center.x, y: wheelLeftFront.center.y))
                leftPath.addLine(to: CGPoint(x: wheelLeftFront.center.x - CGFloat(rover.steeringCircleDistanceInner ?? 0), y: wheelLeftFront.center.y + CGFloat(self.rover.radStand/2)))
                leftPath.close()
                leftShape.path = leftPath.cgPath
                
                
                let rightPath = UIBezierPath()
                rightPath.move(to: CGPoint(x: wheelRightFront.center.x, y: wheelRightFront.center.y + CGFloat(self.rover.radStand/2)))
                rightPath.addLine(to: CGPoint(x: wheelRightFront.center.x, y: wheelRightFront.center.y))
                rightPath.addLine(to: CGPoint(x: wheelRightFront.center.x - CGFloat(rover.steeringCircleDistanceOuter ?? 0), y: wheelRightFront.center.y + CGFloat(self.rover.radStand/2)))
                rightPath.close()
                rightShape.path = rightPath.cgPath
                
            }else if wheel.fl - 80 > 0{
                // nach rechts
                let rightPath = UIBezierPath()
                rightPath.move(to: CGPoint(x: wheelRightFront.center.x, y: wheelRightFront.center.y + CGFloat(self.rover.radStand/2)))
                rightPath.addLine(to: CGPoint(x: wheelRightFront.center.x, y: wheelRightFront.center.y))
                rightPath.addLine(to: CGPoint(x: wheelRightFront.center.x + CGFloat(rover.steeringCircleDistanceInner ?? 0), y: wheelRightFront.center.y + CGFloat(self.rover.radStand/2)))
                rightPath.close()
                rightShape.path = rightPath.cgPath
                
                let leftPath = UIBezierPath()
                leftPath.move(to: CGPoint(x: wheelLeftFront.center.x, y: wheelLeftFront.center.y + CGFloat(self.rover.radStand/2)))
                leftPath.addLine(to: CGPoint(x: wheelLeftFront.center.x, y: wheelLeftFront.center.y))
                leftPath.addLine(to: CGPoint(x: wheelLeftFront.center.x + CGFloat(rover.steeringCircleDistanceOuter ?? 0), y: wheelLeftFront.center.y + CGFloat(self.rover.radStand/2)))
                leftPath.close()
                leftShape.path = leftPath.cgPath
            }else{
                
            }
            
        }
    }
    
    var steeringLeftPoly: CAShapeLayer?
    var steeringRightPoly: CAShapeLayer?
}
