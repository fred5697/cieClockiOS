//
//  ViewController.swift
//  cieClock
//
//  Created by Fred on 2024/9/10.
//

import UIKit


class CieClockView: UIView {
    
    var hourCircleColor: UIColor
    var minuteCircleColor: UIColor
    var secondCircleColor: UIColor
    
    // Custom initializer to pass the colors
    init(frame: CGRect, hourColor: UIColor, minuteColor: UIColor, secondColor: UIColor) {
        self.hourCircleColor = hourColor
        self.minuteCircleColor = minuteColor
        self.secondCircleColor = secondColor
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        
        // Hour circle - outermost
        let hourRadius = min(rect.size.width, rect.size.height) / 2.5
        context.setFillColor(hourCircleColor.cgColor)
        context.addArc(center: center, radius: hourRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.fillPath()

        // Minute circle - middle
        let minuteRadius = hourRadius * 0.7
        context.setFillColor(minuteCircleColor.cgColor)
        context.addArc(center: center, radius: minuteRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.fillPath()

        // Second circle - innermost
        let secondRadius = minuteRadius * 0.6
        context.setFillColor(secondCircleColor.cgColor)
        context.addArc(center: center, radius: secondRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        context.fillPath()
    }
}



class TimeBrickView: UIView {
    
    var hourBrickColor: UIColor
    var minuteBrickColor: UIColor
    var secondBrickColor: UIColor
    
    init(frame: CGRect, hourColor: UIColor, minuteColor: UIColor, secondColor: UIColor) {
        self.hourBrickColor = hourColor
        self.minuteBrickColor = minuteColor
        self.secondBrickColor = secondColor
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let brickHeight = rect.height / 3
        let width = rect.width
        
        // Draw hour brick
        context.setFillColor(hourBrickColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: brickHeight))
        
        // Draw minute brick
        context.setFillColor(minuteBrickColor.cgColor)
        context.fill(CGRect(x: 0, y: brickHeight, width: width, height: brickHeight))
        
        // Draw second brick
        context.setFillColor(secondBrickColor.cgColor)
        context.fill(CGRect(x: 0, y: brickHeight * 2, width: width, height: brickHeight))
    }
}


// In your ViewController, you can now pass your custom colors
class CieClockViewController: UIViewController {
    var cieClockView: CieClockView!
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateClockColors()
        
        // Start a timer to refresh every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClockColors), userInfo: nil, repeats: true)
    }
        
        
        
    @objc func updateClockColors() {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
            
            let cHour = components.hour ?? 0
            let cMin = components.minute ?? 0
            let cSec = components.second ?? 0

            let chrome = 100
            
            var chouri = 360.0 - (Double(cHour - 3) * 30.0)
            if chouri > 360.0 { chouri -= 360.0 }
            
            var cmini = 360.0 - (Double(cMin - 15) * 6.0)
            if cmini > 360.0 { cmini -= 360.0 }
            
            var cseci = 360.0 - (Double(cSec - 15) * 6.0)
            if cseci > 360.0 { cseci -= 360.0 }
            
            let degreeH = chouri * .pi / 180.0
            let degreeM = cmini * .pi / 180.0
            let degreeS = cseci * .pi / 180.0
            
            let Lh = CieClockViewController.getLh(chouri)
            let Lm = CieClockViewController.getLm(cmini)
            let Ls = CieClockViewController.getLs(cseci)
            
            let ah = cos(degreeH) * Double(chrome)
            let bh = sin(degreeH) * Double(chrome)
            let am = cos(degreeM) * Double(chrome)
            let bm = sin(degreeM) * Double(chrome)
            let asVal = cos(degreeS) * Double(chrome)
            let bsVal = sin(degreeS) * Double(chrome)
            
            let xh = lab2xyz("x", l: Double(Lh), a: ah, b: bh) * 0.01
            let yh = lab2xyz("y", l: Double(Lh), a: ah, b: bh) * 0.01
            let zh = lab2xyz("z", l: Double(Lh), a: ah, b: bh) * 0.01

            let xm = lab2xyz("x", l: Double(Lm), a: am, b: bm) * 0.01
            let ym = lab2xyz("y", l: Double(Lm), a: am, b: bm) * 0.01
            let zm = lab2xyz("z", l: Double(Lm), a: am, b: bm) * 0.01
            
            let xs = lab2xyz("x", l: Double(Ls), a: asVal, b: bsVal) * 0.01
            let ys = lab2xyz("y", l: Double(Ls), a: asVal, b: bsVal) * 0.01
            let zs = lab2xyz("z", l: Double(Ls), a: asVal, b: bsVal) * 0.01
            
            let hRGB = CieClockViewController.cieXYZtoSRGB(X: xh, Y: yh, Z: zh)
            let mRGB = CieClockViewController.cieXYZtoSRGB(X: xm, Y: ym, Z: zm)
            let sRGB = CieClockViewController.cieXYZtoSRGB(X: xs, Y: ys, Z: zs)
            
            debugPrint("mLab: ",cMin,":",Lm,",",am,",",bm)
            debugPrint("mRGB: ", mRGB)
            debugPrint("sLab: ",cSec,":",Ls,",",asVal,",",bsVal)
            debugPrint("sRGB: ", sRGB)
        
            let hourCirclePaint = UIColor(red: CGFloat(hRGB[0])/255, green: CGFloat(hRGB[1])/255, blue: CGFloat(hRGB[2])/255, alpha: 1.0)
            let minCirclePaint = UIColor(red: CGFloat(mRGB[0])/255, green: CGFloat(mRGB[1])/255, blue: CGFloat(mRGB[2])/255, alpha: 1.0)
            let secCirclePaint = UIColor(red: CGFloat(sRGB[0])/255, green: CGFloat(sRGB[1])/255, blue: CGFloat(sRGB[2])/255, alpha: 1.0)
            
            if cieClockView != nil {
                cieClockView.removeFromSuperview()
            }
            
            cieClockView = CieClockView(frame: CGRect(x: 0, y: 0, width: 400, height: 400),
                                        hourColor: hourCirclePaint,
                                        minuteColor: minCirclePaint,
                                        secondColor: secCirclePaint)
            cieClockView.center = self.view.center
            cieClockView.backgroundColor = .white
            self.view.addSubview(cieClockView)
        }
    
    static func cieXYZtoSRGB(X: Double, Y: Double, Z: Double) -> [Int] {
        // Normalize XYZ values
        let X = X / 1.0
        let Y = Y / 1.0
        let Z = Z / 1.0

        // Linear transformation from XYZ to RGB
        var R = X *  3.2406 + Y * -1.5372 + Z * -0.4986
        var G = X * -0.9689 + Y *  1.8758 + Z *  0.0415
        var B = X *  0.0557 + Y * -0.2040 + Z *  1.0570

        // Compensate for out-of-range RGB values
        R = (R > 0.0031308) ? (1.055 * pow(R, 1 / 2.4) - 0.055) : (12.92 * R)
        G = (G > 0.0031308) ? (1.055 * pow(G, 1 / 2.4) - 0.055) : (12.92 * G)
        B = (B > 0.0031308) ? (1.055 * pow(B, 1 / 2.4) - 0.055) : (12.92 * B)

        // Clamp RGB values to [0, 1] range
        R = max(0, min(1, R))
        G = max(0, min(1, G))
        B = max(0, min(1, B))

        // Scale to 8-bit sRGB values
        let sR = Int(round(R * 255))
        let sG = Int(round(G * 255))
        let sB = Int(round(B * 255))

        // Return sRGB color array
        return [sR, sG, sB]
    }
    
    
    
    func lab2xyz(_ v: String, l: Double, a: Double, b: Double) -> Double {
        var result: Double = 0.0
        let lPlus16Div116 = (l + 16) / 116.0

        switch v {
        case "x":
            if (lPlus16Div116 + a / 500.0) > 0.206893 {
                result = 96.422 * pow((lPlus16Div116 + a / 500.0), 3)
            } else {
                result = 96.422 / 7.787 * ((lPlus16Div116 + l / 500.0) - 16 / 116.0)
            }

        case "y":
            if lPlus16Div116 > 0.206893 {
                result = 100 * pow(lPlus16Div116, 3)
            } else {
                result = 100 / 7.787 * (lPlus16Div116 - 16 / 116.0)
            }

        case "z":
            if (lPlus16Div116 - b / 200.0) > 0.206893 {
                result = 82.521 * pow((lPlus16Div116 - b / 200.0), 3)
            } else {
                result = 82.521 / 7.787 * ((lPlus16Div116 - b / 200.0) - 16 / 116.0)
            }

        default:
            fatalError("Invalid value for v: \(v)")
        }

        return result
    }
    
    // Helper functions
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
    


    

}



class SecondPageViewController: UIViewController {
        var brickView: TimeBrickView!
        var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateClockColors()
        
        // Start a timer to refresh every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateClockColors), userInfo: nil, repeats: true)
    }
        
        
        
    @objc func updateClockColors() {
        // Define rectangle sizes
        let rectHeight: CGFloat = 100
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: Date())
        
        let cHour = components.hour ?? 0
        let cMin = components.minute ?? 0
        let cSec = components.second ?? 0

        let chrome = 100
        
        var chouri = 360.0 - (Double(cHour - 3) * 30.0)
        if chouri > 360.0 { chouri -= 360.0 }
        
        var cmini = 360.0 - (Double(cMin - 15) * 6.0)
        if cmini > 360.0 { cmini -= 360.0 }
        
        var cseci = 360.0 - (Double(cSec - 15) * 6.0)
        if cseci > 360.0 { cseci -= 360.0 }
        
        let degreeH = chouri * .pi / 180.0
        let degreeM = cmini * .pi / 180.0
        let degreeS = cseci * .pi / 180.0
        
        let Lh = SecondPageViewController.getLh(chouri)
        let Lm = SecondPageViewController.getLm(cmini)
        let Ls = SecondPageViewController.getLs(cseci)
        
        let ah = cos(degreeH) * Double(chrome)
        let bh = sin(degreeH) * Double(chrome)
        let am = cos(degreeM) * Double(chrome)
        let bm = sin(degreeM) * Double(chrome)
        let asVal = cos(degreeS) * Double(chrome)
        let bsVal = sin(degreeS) * Double(chrome)
        
        let xh = lab2xyz("x", l: Double(Lh), a: ah, b: bh) * 0.01
        let yh = lab2xyz("y", l: Double(Lh), a: ah, b: bh) * 0.01
        let zh = lab2xyz("z", l: Double(Lh), a: ah, b: bh) * 0.01

        let xm = lab2xyz("x", l: Double(Lm), a: am, b: bm) * 0.01
        let ym = lab2xyz("y", l: Double(Lm), a: am, b: bm) * 0.01
        let zm = lab2xyz("z", l: Double(Lm), a: am, b: bm) * 0.01
        
        let xs = lab2xyz("x", l: Double(Ls), a: asVal, b: bsVal) * 0.01
        let ys = lab2xyz("y", l: Double(Ls), a: asVal, b: bsVal) * 0.01
        let zs = lab2xyz("z", l: Double(Ls), a: asVal, b: bsVal) * 0.01
        
        let hRGB = CieClockViewController.cieXYZtoSRGB(X: xh, Y: yh, Z: zh)
        let mRGB = CieClockViewController.cieXYZtoSRGB(X: xm, Y: ym, Z: zm)
        let sRGB = CieClockViewController.cieXYZtoSRGB(X: xs, Y: ys, Z: zs)
        
        
        
        // Hour Rectangle
        let hourRect = UIView(frame: CGRect(x: 50, y: 100, width: 300, height: rectHeight))
        hourRect.backgroundColor = UIColor(red: CGFloat(hRGB[0])/255, green: CGFloat(hRGB[1])/255, blue: CGFloat(hRGB[2])/255, alpha: 1.0) // Replace with dynamic hour color
        view.addSubview(hourRect)
        
        // Minute Rectangle
        let minuteRect = UIView(frame: CGRect(x: 50, y: 220, width: 300, height: rectHeight))
        minuteRect.backgroundColor = UIColor(red: CGFloat(mRGB[0])/255, green: CGFloat(mRGB[1])/255, blue: CGFloat(mRGB[2])/255, alpha: 1.0) // Replace with dynamic hour color
        view.addSubview(minuteRect)
        
        // Second Rectangle
        let secondRect = UIView(frame: CGRect(x: 50, y: 340, width: 300, height: rectHeight))
        secondRect.backgroundColor = UIColor(red: CGFloat(sRGB[0])/255, green: CGFloat(sRGB[1])/255, blue: CGFloat(sRGB[2])/255, alpha: 1.0) // Replace with dynamic hour color
        view.addSubview(secondRect)
    }
    
    
    static func cieXYZtoSRGB(X: Double, Y: Double, Z: Double) -> [Int] {
        // Normalize XYZ values
        let X = X / 1.0
        let Y = Y / 1.0
        let Z = Z / 1.0

        // Linear transformation from XYZ to RGB
        var R = X *  3.2406 + Y * -1.5372 + Z * -0.4986
        var G = X * -0.9689 + Y *  1.8758 + Z *  0.0415
        var B = X *  0.0557 + Y * -0.2040 + Z *  1.0570

        // Compensate for out-of-range RGB values
        R = (R > 0.0031308) ? (1.055 * pow(R, 1 / 2.4) - 0.055) : (12.92 * R)
        G = (G > 0.0031308) ? (1.055 * pow(G, 1 / 2.4) - 0.055) : (12.92 * G)
        B = (B > 0.0031308) ? (1.055 * pow(B, 1 / 2.4) - 0.055) : (12.92 * B)

        // Clamp RGB values to [0, 1] range
        R = max(0, min(1, R))
        G = max(0, min(1, G))
        B = max(0, min(1, B))

        // Scale to 8-bit sRGB values
        let sR = Int(round(R * 255))
        let sG = Int(round(G * 255))
        let sB = Int(round(B * 255))

        // Return sRGB color array
        return [sR, sG, sB]
    }
    
    
    
    func lab2xyz(_ v: String, l: Double, a: Double, b: Double) -> Double {
        var result: Double = 0.0
        let lPlus16Div116 = (l + 16) / 116.0

        switch v {
        case "x":
            if (lPlus16Div116 + a / 500.0) > 0.206893 {
                result = 96.422 * pow((lPlus16Div116 + a / 500.0), 3)
            } else {
                result = 96.422 / 7.787 * ((lPlus16Div116 + l / 500.0) - 16 / 116.0)
            }

        case "y":
            if lPlus16Div116 > 0.206893 {
                result = 100 * pow(lPlus16Div116, 3)
            } else {
                result = 100 / 7.787 * (lPlus16Div116 - 16 / 116.0)
            }

        case "z":
            if (lPlus16Div116 - b / 200.0) > 0.206893 {
                result = 82.521 * pow((lPlus16Div116 - b / 200.0), 3)
            } else {
                result = 82.521 / 7.787 * ((lPlus16Div116 - b / 200.0) - 16 / 116.0)
            }

        default:
            fatalError("Invalid value for v: \(v)")
        }

        return result
    }
    
    // Helper functions
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
    
    
}


class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var pageViews: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the two view controllers (first and second page)
        let firstPageVC = CieClockViewController() // Your existing clock page
        let secondPageVC = SecondPageViewController() // The brick layout page

        pageViews = [firstPageVC, secondPageVC]
        
        // Create PageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        // Set the initial view controller
        if let firstVC = pageViews.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        // Add PageViewController as child view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViews.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pageViews[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViews.firstIndex(of: viewController), index < pageViews.count - 1 else {
            return nil
        }
        return pageViews[index + 1]
    }
}
