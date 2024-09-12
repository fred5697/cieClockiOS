//
//  colorTool.swift
//  cieClock
//
//  Created by Fred on 2024/9/10.
//

import Foundation

class ColorTool {

    static func lab2xyz(_ v: String, l: Double, a: Double, b: Double) -> Double {
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

    static func cieXYZtoSRGB(_ X: Double, Y: Double, Z: Double) -> [Int] {
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

    static func rgbToHex(r: Int, g: Int, b: Int) -> String {
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
