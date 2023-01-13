//
//  File.swift
//  
//
//  Created by Botirjon Nasridinov on 07/01/23.
//

import UIKit



public class BNLineGraphView: UIView {
    
    private var didDrawGraphs: Bool = false
    
    public var axisMarkAttributes: BNLineGraphAxisMarkAttributes = .init() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var xAxisMarks: [BNLineGraphAxisMark] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var yAxisMarks: [BNLineGraphAxisMark] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var graphInsets: UIEdgeInsets = .init(top: 10, left: 50, bottom: 20, right: 50) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    public var graphs: [BNSingleLineGraph] = [] {
        didSet {
            self.boundaryValues = graphs.findBoundaryValues()
            drawGraphs(graphs)
            didDrawGraphs = true
        }
    }
    
    private var boundaryValues: BNLineGraphBoundaryValues = .init() {
        didSet {
            containerView.subviews.forEach { subview in
                if let graphView = subview as? BNSingleLineGraphView {
                    graphView.boundaryValues = boundaryValues
                }
            }
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
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .clear
        addSubview(containerView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = .init(x: bounds.minX+graphInsets.left, y: bounds.minY+graphInsets.top, width: bounds.width-graphInsets.left-graphInsets.right, height: bounds.height-graphInsets.top-graphInsets.bottom)
        containerView.subviews.forEach { subview in
            subview.frame = subview.superview!.bounds
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawGraphs(_ graphs: [BNSingleLineGraph]) -> Void {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        graphs.forEach { graph in
            let graphView = BNSingleLineGraphView()
            graphView.setValues(graph.values)
            graphView.tintColor = graph.color
            graphView.boundaryValues = self.boundaryValues
            graphView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(graphView)
            graphView.frame = graphView.superview!.bounds
        }
    }

    public func setGraphs(_ graphs: [BNSingleLineGraph]) {
        self.graphs = graphs
    }
    
    public override func draw(_ rect: CGRect) {

        let ratioX = (rect.maxX-graphInsets.left-graphInsets.right)/CGFloat(maxX-minX)
        let ratioY = (rect.maxY-graphInsets.top-graphInsets.bottom)/CGFloat(maxY-minY)
        
        xAxisMarks.forEach { mark in
            
            var x = CGFloat(mark.value)*ratioX-CGFloat(minX)*ratioX // zero reference
            
            x += graphInsets.left // offset by inset

            let attr = mark.attributes ?? axisMarkAttributes
            
            let height = "Tg".attributedString(adding: attr.attributes).height(withConstrainedWidth: 100)
            
            let width = mark.attributedString.width(withConstrainedHeight: height)
            
            x -= width/2
            
            mark.attributedString(defaultAttributes: axisMarkAttributes).draw(at: .init(x: x, y: rect.maxY-height))
        }
        
        yAxisMarks.forEach { mark in
            var y = CGFloat(mark.value)*ratioY-CGFloat(minY)*ratioY
            
            y += graphInsets.top
            
            let attr = mark.attributes ?? axisMarkAttributes
            
            let height = "Tg".attributedString(adding: attr.attributes).height(withConstrainedWidth: 100)
            
            // Mirror the about x
            y = y*cos(.pi)+rect.maxY
            
            y -= graphInsets.top
            y -= height/2
            
            mark.attributedString(defaultAttributes: axisMarkAttributes).draw(at: .init(x: 0, y: y))
        }
    }
}
