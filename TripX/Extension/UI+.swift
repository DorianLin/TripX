//
//  UI+.swift
//  TripX
//
//  Created by JL on 2022/3/22.
//

import SwiftUI


/// Color
let AppThemeColor = Color(hex: 0x0E407D)
let AppColorPink = Color(hex: 0xFE3C30)
let AppColorBlue = Color(hex: 0x007AFF)
let AppUIColorBlue = UIColor(hex: 0x007AFF)


extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255.0,
            G: CGFloat((hex >> 08) & 0xff) / 255.0,
            B: CGFloat((hex >> 00) & 0xff) / 255.0
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1.0)
    }
}

extension Color {
    
    init(hex: Int) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B)
    }
    
}

extension UIImage {
    
    func saveAsTripImage(_ named: String) {
        
        let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("TripImages")
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            try? FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        if let data = self.pngData() {
            let filePath = folderPath.appendingPathComponent(named)
            try? data.write(to: filePath)
        }
    }
    
    static func tripImage(_ named: String) -> UIImage? {
        let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("TripImages")
        if !FileManager.default.fileExists(atPath: folderPath.path) {
            try? FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = folderPath.appendingPathComponent(named)
        
        return UIImage(contentsOfFile: filePath.path)
    }
}
