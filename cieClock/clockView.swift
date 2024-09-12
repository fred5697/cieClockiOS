//
//  clockView.swift
//  cieClock
//
//  Created by Fred on 2024/9/10.
//

import Foundation
import UIKit


class ClockView: UIView {
    var hourCirclePaint: UIColor = .clear
    var minCirclePaint: UIColor = .clear
    var secCirclePaint: UIColor = .clear
    var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        // Start a timer to update the view every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateView), userInfo: nil, repeats: true)
    }

    @objc private func updateView() {
        // Redraw the view
        setNeedsDisplay()

        // Set circle colors (Assuming TimesColorService exists in your Swift codebase)
        let timesHex = TimesColorService.getTimeHex()
        hourCirclePaint = UIColor(hex: timesHex[0])
        minCirclePaint = UIColor(hex: timesHex[1])
        secCirclePaint = UIColor(hex: timesHex[2])
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Draw circles with hourCirclePaint, minCirclePaint, secCirclePaint
        // Assuming positions and sizes for simplicity
        context.setFillColor(hourCirclePaint.cgColor)
        context.fillEllipse(in: CGRect(x: 50, y: 50, width: 100, height: 100))
        
        context.setFillColor(minCirclePaint.cgColor)
        context.fillEllipse(in: CGRect(x: 200, y: 50, width: 100, height: 100))

        context.setFillColor(secCirclePaint.cgColor)
        context.fillEllipse(in: CGRect(x: 350, y: 50, width: 100, height: 100))
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex
        
        // Remove the # if it exists
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        // Convert hex string to UInt64
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        // Extract RGB components
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        // Initialize UIColor with the extracted components
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

