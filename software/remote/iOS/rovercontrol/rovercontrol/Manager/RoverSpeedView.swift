//
//  RoverSpeedView.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 04.05.21.
//

import UIKit

class RoverSpeedView: UIView {
    
    var rover: Rover
    
    var marker: UIView
    
    var label: UILabel
    
    init(withRover r:Rover) {
        
        self.rover = r
        
        self.marker = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 3))
        self.label = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 20))
        
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let circle = UIView(frame: self.frame)
        circle.layer.cornerRadius = circle.frame.size.width / 2
        circle.backgroundColor = .darkGray
        
        self.addSubview(circle)
        
        self.marker.backgroundColor = .yellow
        
        self.addSubview(self.marker)
        
        self.marker.center = CGPoint(x: 50, y: 50)
        self.label.textAlignment = .center
        self.addSubview(self.label)
        
        self.label.text = "\(0)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateInformation(_ x:Float, _ y: Float) {
        //print("updateInformation: \(x) x \(y)")
        
        self.marker.center = CGPoint(x: CGFloat(x * 50) + 50, y: CGFloat(-y * 50) + 50)
        
        
//        var power = Float(sqrt(pow(0, 2) + pow(y, 2)))
//        if power > 1.0 {
//            power = 1.0
//        }
        
        let positiveX = x >= 0 ? x : x * -1
        
        var power:Float = Float(y * (1 + positiveX))
        if power > 1.0 {
            power = 1.0
        }else if power < -1 {
            power = -1
        }
        
        self.label.text = "\(power)"
        
    }
}
