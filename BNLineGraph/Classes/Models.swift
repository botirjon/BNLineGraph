//
//  File.swift
//  
//
//  Created by Botirjon Nasridinov on 07/01/23.
//

import UIKit

public struct BNLineGraphAxisMarkAttributes {
    public var color: UIColor = .black
    public var font: UIFont = .systemFont(ofSize: 12)
    
    public init(color: UIColor = .black, font: UIFont = .systemFont(ofSize: 12)) {
        self.color = color
        self.font = font
    }
    
    internal var attributes: [NSAttributedString.Key: Any] {
        [
            .foregroundColor: color,
            .font: font
        ]
    }
}

public struct BNLineGraphAxisMark {
    public var label: String = ""
    public var value: Float
    public var attributes: BNLineGraphAxisMarkAttributes?
    
    public init(label: String = "", value: Float, attributes: BNLineGraphAxisMarkAttributes? = nil) {
        self.label = label
        self.value = value
        self.attributes = attributes
    }
    
    internal var attributedString: NSAttributedString {
        let text = label.isEmpty ? "\(value)" : label
        let attr = attributes ?? .init()
        return text.attributedString(adding: attr.attributes)
    }
    
    internal func attributedString(defaultAttributes: BNLineGraphAxisMarkAttributes = .init()) -> NSAttributedString {
        let text = label.isEmpty ? "\(value)" : label
        let attr = attributes ?? defaultAttributes
        return text.attributedString(adding: attr.attributes)
    }
}

public struct BNLineGraphVariable {
    public var label: String = ""
    public var value: Float
    
    public init(label: String = "", value: Float) {
        self.label = label
        self.value = value
    }
}

public struct BNLineGraphPoint {
    public var dependentVariable: BNLineGraphVariable
    public var independentVariable: BNLineGraphVariable
    
    public init(dependentVariable: BNLineGraphVariable, independentVariable: BNLineGraphVariable) {
        self.dependentVariable = dependentVariable
        self.independentVariable = independentVariable
    }
}

public struct BNSingleLineGraph {
    public var color: UIColor
    public var values: [BNLineGraphPoint] = []
    
    public init(color: UIColor, values: [BNLineGraphPoint] = []) {
        self.color = color
        self.values = values
    }
}


internal struct BNSingleLineGraphPoints {
    var color: UIColor
    var points: [CGPoint] = []
    
    init(color: UIColor, points: [CGPoint] = []) {
        self.color = color
        self.points = points
    }
}


internal struct BNLineGraphBoundaryValues {
    var minX: Float = 0
    var minY: Float = 0
    var maxX: Float = 0
    var maxY: Float = 0
    
    init(minX: Float = 0, minY: Float = 0, maxX: Float = 0, maxY: Float = 0) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
}
