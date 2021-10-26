//
//  SettingsManager.swift
//  rovercontrol
//
//  Created by Jeanette Müller on 25.10.21.
//

import Foundation


class GlobalSettings {
    enum Environment: Int {
        case Normal, Dev
    }
}


extension GlobalSettings {
    
    class func setEnvironment(_ val: Environment) {
        UserDefaults.standard.set(val.rawValue, forKey: "settings_environment")
    }
    class func getEnvironment() -> Environment {
        let val = UserDefaults.standard.integer(forKey: "settings_environment")
        return Environment.init(rawValue: val) ?? .Normal
    }
}

extension GlobalSettings {
    
    class func setCalibrationFrontLeft(_ val: Float) {
        UserDefaults.standard.set(val, forKey: "settings_calibration_front_left")
    }
    class func getCalibrationFrontLeft() -> Float {
        return UserDefaults.standard.float(forKey: "settings_calibration_front_left")
    }
    
    class func setCalibrationFrontRight(_ val: Float) {
        UserDefaults.standard.set(val, forKey: "settings_calibration_front_right")
    }
    class func getCalibrationFrontRight() -> Float {
        return UserDefaults.standard.float(forKey: "settings_calibration_front_right")
    }
    
    class func setCalibrationBackLeft(_ val: Float) {
        UserDefaults.standard.set(val, forKey: "settings_calibration_back_left")
    }
    class func getCalibrationBackLeft() -> Float {
        return UserDefaults.standard.float(forKey: "settings_calibration_back_left")
    }
    
    class func setCalibrationBackRight(_ val: Float) {
        UserDefaults.standard.set(val, forKey: "settings_calibration_back_right")
    }
    class func getCalibrationBackRight() -> Float {
        return UserDefaults.standard.float(forKey: "settings_calibration_back_right")
    }
}
