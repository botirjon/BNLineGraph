//
//  ViewController.swift
//  BNLineGraph
//
//  Created by botirjon on 01/10/2023.
//  Copyright (c) 2023 botirjon. All rights reserved.
//

import UIKit
import BNLineGraph

class ViewController: UIViewController {

    private lazy var lineGraph: BNLineGraphView = {
        let lineGraph = BNLineGraphView()
        lineGraph.translatesAutoresizingMaskIntoConstraints = false
        return lineGraph
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lineGraph)
        NSLayoutConstraint.activate([
            lineGraph.centerXAnchor.constraint(equalTo: lineGraph.superview!.centerXAnchor),
            lineGraph.centerYAnchor.constraint(equalTo: lineGraph.superview!.centerYAnchor),
            lineGraph.widthAnchor.constraint(equalTo: lineGraph.superview!.widthAnchor),
            lineGraph.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let v1: [BNLineGraphPoint] = [
            .init(dependentVariable: .init(value: 100), independentVariable: .init(value: 10)),
            .init(dependentVariable: .init(value: 20), independentVariable: .init(value: 20)),
            .init(dependentVariable: .init(value: 80), independentVariable: .init(value: 30)),
            .init(dependentVariable: .init(value: 10), independentVariable: .init(value: 40))
        ]
        
        let v2: [BNLineGraphPoint] = [
            .init(dependentVariable: .init(value: 10), independentVariable: .init(value: 10)),
            .init(dependentVariable: .init(value: 80), independentVariable: .init(value: 20)),
            .init(dependentVariable: .init(value: 20), independentVariable: .init(value: 30)),
            .init(dependentVariable: .init(value: 100), independentVariable: .init(value: 40))
        ]
        
        let graphs: [BNSingleLineGraph] = [
            .init(color: .init(hex: "#FB2D2E"), values: v1),
            .init(color: .init(hex: "#03BA83"), values: v2)
        ]
        
        lineGraph.graphs = graphs
        lineGraph.xAxisMarks = [
            .init(label: "9:00", value: 10),
            .init(label: "12:00", value: 20),
            .init(label: "15:00", value: 30),
            .init(label: "18:00", value: 40)
        ]
        lineGraph.yAxisMarks = [
            .init(label: "20k", value: 20),
            .init(label: "40k", value: 40),
            .init(label: "60k", value: 60),
            .init(label: "80k", value: 80),
            .init(label: "100k", value: 100)
        ]
        lineGraph.axisMarkAttributes = .init(color: .init(hex: "#7E8392"), font: .systemFont(ofSize: 9))
    }
}




fileprivate extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}

fileprivate extension UIColor {
    static func random() -> UIColor {
        return UIColor.init(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
    
    convenience init(hex aString: String, alpha: CGFloat = 1.0) {
        let hexString: String = (aString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: aString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var hex: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    convenience init(_ red: UInt, _ green: UInt, _ blue: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red)/255.0,
                  green: CGFloat(green)/255.0,
                  blue: CGFloat(blue)/255.0,
                  alpha: alpha)
    }
}

fileprivate extension CGColor {
    static var random: CGColor {
        return UIColor.random().cgColor
    }
}
