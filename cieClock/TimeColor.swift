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
        if (chouri > 53 && chouri < 59)   { return 60 }
        if (chouri > 59 && chouri < 65)  { return 65 }
        if chouri > 65 && chouri < 71 { return 70 }
        if chouri > 71 && chouri < 77 { return 75 }
        if chouri > 77 && chouri < 83 { return 80 }
        if chouri > 83 && chouri < 89 { return 85 }
        if chouri > 89 && chouri < 101 { return 93 }
        if chouri > 101 && chouri < 107 { return 92 }
        if chouri > 107 && chouri < 113 { return 90 }
        if chouri > 113 && chouri < 119 { return 88 }
        if chouri > 119 && chouri < 125 { return 85 }
        if chouri > 125 && chouri < 131 { return 83 }
        if chouri > 131 && chouri < 137 { return 80 }
        if chouri > 137 && chouri < 143 { return 78 }
        if chouri > 143 && chouri < 149 { return 75 }
        if chouri > 149 && chouri < 155 { return 70 }
        if chouri > 155 && chouri < 161 { return 68 }
        if chouri > 161 && chouri < 167 { return 65 }
        if chouri > 167 && chouri < 173 { return 63 }
        if chouri > 173 && chouri < 179 { return 60 }
        if chouri > 179 && chouri < 185  { return 58 }
        if chouri > 185 { return 55 }
        // Additional conditions...
        return 55
    }

    private static func getLm(_ cmini: Double) -> Int {
        // Logic for getting Lm from cmini
        if (cmini > 53 && cmini < 59)   { return 60 }
        if (cmini > 59 && cmini < 65)  { return 65 }
        if cmini > 65 && cmini < 71 { return 70 }
        if cmini > 71 && cmini < 77 { return 75 }
        if cmini > 77 && cmini < 83 { return 80 }
        if cmini > 83 && cmini < 89 { return 85 }
        if cmini > 89 && cmini < 101 { return 93 }
        if cmini > 101 && cmini < 107 { return 92 }
        if cmini > 107 && cmini < 113 { return 90 }
        if cmini > 113 && cmini < 119 { return 88 }
        if cmini > 119 && cmini < 125 { return 85 }
        if cmini > 125 && cmini < 131 { return 83 }
        if cmini > 131 && cmini < 137 { return 80 }
        if cmini > 137 && cmini < 143 { return 78 }
        if cmini > 143 && cmini < 149 { return 75 }
        if cmini > 149 && cmini < 155 { return 70 }
        if cmini > 155 && cmini < 161 { return 68 }
        if cmini > 161 && cmini < 167 { return 65 }
        if cmini > 167 && cmini < 173 { return 63 }
        if cmini > 173 && cmini < 179 { return 60 }
        if cmini > 179 && cmini < 185  { return 58 }
        if cmini > 185 { return 55 }
        // Additional conditions...
        return 55
    }

    private static func getLs(_ cseci: Double) -> Int {
        // Logic for getting Ls from cseci
        debugPrint("cseci: ",cseci)
        if (cseci > 53 && cseci < 59)   { return 60 }
        if (cseci > 59 && cseci < 65)  { return 65 }
        if cseci > 65 && cseci < 71 { return 70 }
        if cseci > 71 && cseci < 77 { return 75 }
        if cseci > 77 && cseci < 83 { return 80 }
        if cseci > 83 && cseci < 89 { return 85 }
        if cseci > 89 && cseci < 101 { return 93 }
        if cseci > 101 && cseci < 107 { return 92 }
        if cseci > 107 && cseci < 113 { return 90 }
        if cseci > 113 && cseci < 119 { return 88 }
        if cseci > 119 && cseci < 125 { return 85 }
        if cseci > 125 && cseci < 131 { return 83 }
        if cseci > 131 && cseci < 137 { return 80 }
        if cseci > 137 && cseci < 143 { return 78 }
        if cseci > 143 && cseci < 149 { return 75 }
        if cseci > 149 && cseci < 155 { return 70 }
        if cseci > 155 && cseci < 161 { return 68 }
        if cseci > 161 && cseci < 167 { return 65 }
        if cseci > 167 && cseci < 173 { return 63 }
        if cseci > 173 && cseci < 179 { return 60 }
        if cseci > 179 && cseci < 185  { return 58 }
        if cseci > 185 { return 55 }
        // Additional conditions...
        return 55
    }

    private static func getLd(_ cDayi: Double) -> Int {
        // Logic for getting Ld from cDayi
        if (cDayi > 53 && cDayi < 59)   { return 60 }
        if (cDayi > 59 && cDayi < 65)  { return 65 }
        if cDayi > 65 && cDayi < 71 { return 70 }
        if cDayi > 71 && cDayi < 77 { return 75 }
        if cDayi > 77 && cDayi < 83 { return 80 }
        if cDayi > 83 && cDayi < 89 { return 85 }
        if cDayi > 89 && cDayi < 101 { return 93 }
        if cDayi > 101 && cDayi < 107 { return 92 }
        if cDayi > 107 && cDayi < 113 { return 90 }
        if cDayi > 113 && cDayi < 119 { return 88 }
        if cDayi > 119 && cDayi < 125 { return 85 }
        if cDayi > 125 && cDayi < 131 { return 83 }
        if cDayi > 131 && cDayi < 137 { return 80 }
        if cDayi > 137 && cDayi < 143 { return 78 }
        if cDayi > 143 && cDayi < 149 { return 75 }
        if cDayi > 149 && cDayi < 155 { return 70 }
        if cDayi > 155 && cDayi < 161 { return 68 }
        if cDayi > 161 && cDayi < 167 { return 65 }
        if cDayi > 167 && cDayi < 173 { return 63 }
        if cDayi > 173 && cDayi < 179 { return 60 }
        if cDayi > 179 && cDayi < 185  { return 58 }
        if cDayi > 185 { return 55 }
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

