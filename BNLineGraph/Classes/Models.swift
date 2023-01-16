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
    public var value: CGFloat
    public var attributes: BNLineGraphAxisMarkAttributes?
    
    public init(label: String = "", value: CGFloat, attributes: BNLineGraphAxisMarkAttributes? = nil) {
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

//public struct BNLineGraphVariable {
//    public var label: String = ""
//    public var value: CGFloat
//    
//    public init(label: String = "", value: CGFloat) {
//        self.label = label
//        self.value = value
//    }
//}

public typealias BNLineGraphPoint = CGPoint

//public struct BNLineGraphPoint {
//    public var y: BNLineGraphVariable
//    public var x: BNLineGraphVariable
//
//    public init(dependentVariable: BNLineGraphVariable, independentVariable: BNLineGraphVariable) {
//        self.y = dependentVariable
//        self.x = independentVariable
//    }
//}

public struct BNSingleLineGraph {
    public var color: UIColor
    public var values: [BNLineGraphPoint] = []
    
    public init(color: UIColor, values: [BNLineGraphPoint] = []) {
        self.color = color
        self.values = values
    }
}

internal struct BNLineGraphBoundaryValues {
    var minX: CGFloat = 0
    var minY: CGFloat = 0
    var maxX: CGFloat = 0
    var maxY: CGFloat = 0
    
    init(minX: CGFloat = 0, minY: CGFloat = 0, maxX: CGFloat = 0, maxY: CGFloat = 0) {
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
}
