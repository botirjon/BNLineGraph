//
//  BNSingleLineGraphView.swift
//  BNLineGraph
//
//  Created by Botirjon Nasridinov on 13/01/23.
//

import UIKit

public class BNSingleLineGraphView: UIView {
    
    private var values: [BNLineGraphPoint] = [] {
        didSet {
            self.boundaryValues = values.findBoundaryValues()
//            setNeedsDisplay()
        }
    }
    
    var boundaryValues: BNLineGraphBoundaryValues = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var maxX: Float { boundaryValues.maxX }
    private var maxY: Float { boundaryValues.maxY }
    private var minX: Float { boundaryValues.minX }
    private var minY: Float { boundaryValues.minY }
    
    public override var backgroundColor: UIColor? {
        set {
            super.backgroundColor = .clear
        }
        get {
            super.backgroundColor
        }
    }
    
    public var lineWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func initView() {
        isOpaque = false
        backgroundColor = .clear
    }
    
    
    
    public func setValues(_ values: [BNLineGraphPoint]) {
        
        self.values = values.sorted(by: {
            $0.independentVariable.value < $1.independentVariable.value
        })
    }
    
    
    
    private func mapValuesToPoints(for rect: CGRect) -> [CGPoint] {
        
        
        let ratioX = rect.maxX/CGFloat(maxX-minX)
        let ratioY = rect.maxY/CGFloat(maxY-minY)
        
        return values.map { point in
            var y = CGFloat(point.dependentVariable.value)*ratioY-CGFloat(minY)*ratioY
            y = y*cos(.pi)+rect.maxY
            let x = CGFloat(point.independentVariable.value)*ratioX-CGFloat(minX)*ratioX
            return .init(x: x, y: y)
        }
    }
    
    
    public override func draw(_ rect: CGRect) {
        
        guard !values.isEmpty else { return }
        
        // 1. Calculate the graph points
        let points = self.mapValuesToPoints(for: rect)
        
        
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        tintColor.setFill()
        tintColor.setStroke()
        let graphPath = UIBezierPath()
        graphPath.lineWidth = lineWidth
        graphPath.lineJoinStyle = .round
        
        points.enumerated().forEach { (index, point) in
            if index == 0 {
                graphPath.move(to: point)
            } else {
                graphPath.addLine(to: point)
            }
        }
        
        graphPath.stroke()
        
        
        // Add clipping path
        guard let clippingPath = graphPath.copy() as? UIBezierPath else { return }
        
        clippingPath.addLine(to: .init(x: points[points.count-1].x, y: rect.maxY))
        clippingPath.addLine(to: .init(x: points[0].x, y: rect.maxY))
        clippingPath.close()
        clippingPath.addClip()
        
        let graphStartPoint = CGPoint(x: points[0].x, y: 0)
        let graphEndPoint = CGPoint(x: points[0].x, y: rect.maxY)
        
        let colors = [tintColor.withAlphaComponent(0.2).cgColor, tintColor.withAlphaComponent(0).cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
    }
}
