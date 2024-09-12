//
//  TimeColor.swift
//  cieClock
//
//  Created by Fred on 2024/9/10.
//

import Foundation
import UIKit

class TimesColorService {
    
    static func getTimeHex() -> [String] {
        
        let calendar = Calendar.current
        let date = Date()

        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)
        print(dayOfYear ?? "Error calculating day of year")
        
        //let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        let cHour = components.hour ?? 0
        let cMin = components.minute ?? 0
        let cSec = components.second ?? 0
        let cDay = dayOfYear ?? 0

        let cDayi = (Double(cDay) / 365.0) * 360.0

        // Calculate the angles of the hour, minute, and second hands
        var chouri = 360.0 - (Double(cHour - 3) * 30.0)
        if chouri > 360.0 { chouri -= 360.0 }
        
        var cmini = 360.0 - (Double(cMin - 15) * 6.0)
        if cmini > 360.0 { cmini -= 360.0 }
        
        var cseci = 360.0 - (Double(cSec - 15) * 6.0)
        if cseci > 360.0 { cseci -= 360.0 }
        
        let chrome = 100
        let Lh = getLh(chouri)
        let Lm = getLm(cmini)
        let Ls = getLs(cseci)
        let Ld = getLd(cDayi)

        // Convert degrees to radians
        let degreeH = chouri * .pi / 180.0
        let degreeM = cmini * .pi / 180.0
        let degreeS = cseci * .pi / 180.0
        let degreed = cDayi * .pi / 180.0
        
        let ah = cos(degreeH) * Double(chrome)
        let bh = sin(degreeH) * Double(chrome)
        let am = cos(degreeM) * Double(chrome)
        let bm = sin(degreeM) * Double(chrome)
        let asVal = cos(degreeS) * Double(chrome)
        let bsVal = sin(degreeS) * Double(chrome)
        let ad = cos(degreed) * Double(chrome)
        let bd = sin(degreed) * Double(chrome)
        
        let xh = lab2xyz("x", Lh, ah, bh) * 0.01
        let yh = lab2xyz("y", Lh, ah, bh) * 0.01
        let zh = lab2xyz("z", Lh, ah, bh) * 0.01

        let xm = lab2xyz("x", Lm, am, bm) * 0.01
        let ym = lab2xyz("y", Lm, am, bm) * 0.01
        let zm = lab2xyz("z", Lm, am, bm) * 0.01

        let xs = lab2xyz("x", Ls, asVal, bsVal) * 0.01
        let ys = lab2xyz("y", Ls, asVal, bsVal) * 0.01
        let zs = lab2xyz("z", Ls, asVal, bsVal) * 0.01

        let xd = lab2xyz("x", Ld, ad, bd) * 0.01
        let yd = lab2xyz("y", Ld, ad, bd) * 0.01
        let zd = lab2xyz("z", Ld, ad, bd) * 0.01

        let hRGB = cieXYZtoSRGB(xh, yh, zh)
        let mRGB = cieXYZtoSRGB(xm, ym, zm)
        let sRGB = cieXYZtoSRGB(xs, ys, zs)
        let dRGB = cieXYZtoSRGB(xd, yd, zd)

        let hexH = String(format: "#%02x%02x%02x", hRGB[0], hRGB[1], hRGB[2])
        let hexM = String(format: "#%02x%02x%02x", mRGB[0], mRGB[1], mRGB[2])
        let hexS = String(format: "#%02x%02x%02x", sRGB[0], sRGB[1], sRGB[2])
        let hexD = String(format: "#%02x%02x%02x", dRGB[0], dRGB[1], dRGB[2])

        let colorH = UIColor(red: CGFloat(hRGB[0]) / 255.0, green: CGFloat(hRGB[1]) / 255.0, blue: CGFloat(hRGB[2]) / 255.0, alpha: 1.0)
        let colorM = UIColor(red: CGFloat(mRGB[0]) / 255.0, green: CGFloat(mRGB[1]) / 255.0, blue: CGFloat(mRGB[2]) / 255.0, alpha: 1.0)
        let colorS = UIColor(red: CGFloat(sRGB[0]) / 255.0, green: CGFloat(sRGB[1]) / 255.0, blue: CGFloat(sRGB[2]) / 255.0, alpha: 1.0)
        let colorD = UIColor(red: CGFloat(dRGB[0]) / 255.0, green: CGFloat(dRGB[1]) / 255.0, blue: CGFloat(dRGB[2]) / 255.0, alpha: 1.0)

        return [hexH, hexM, hexS, hexD, "\(colorH)", "\(colorM)", "\(colorS)", "\(colorD)"]
    }

    private static func getLh(_ chouri: Double) -> Int {
        // Logic for getting Lh from chouri
        if chouri > 53 { return 60 }
        if chouri > 59 { return 65 }
        // Additional conditions...
        return 55
    }

    private static func getLm(_ cmini: Double) -> Int {
        // Logic for getting Lm from cmini
        if cmini > 53 { return 60 }
        if cmini > 59 { return 65 }
        // Additional conditions...
        return 55
    }

    private static func getLs(_ cseci: Double) -> Int {
        // Logic for getting Ls from cseci
        if cseci > 53 { return 60 }
        if cseci > 59 { return 65 }
        // Additional conditions...
        return 55
    }

    private static func getLd(_ cDayi: Double) -> Int {
        // Logic for getting Ld from cDayi
        if cDayi > 53 { return 60 }
        if cDayi > 59 { return 65 }
        // Additional conditions...
        return 55
    }

    // Lab to XYZ conversion (mock implementation)
    private static func lab2xyz(_ component: String, _ L: Int, _ a: Double, _ b: Double) -> Double {
        // Mock conversion function
        return Double(L) + a + b
    }

    // XYZ to sRGB conversion (mock implementation)
    private static func cieXYZtoSRGB(_ X: Double, _ Y: Double, _ Z: Double) -> [Int] {
        // Mock conversion function
        return [Int(X), Int(Y), Int(Z)]
    }
    
}

