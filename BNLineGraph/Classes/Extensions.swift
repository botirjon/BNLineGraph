//
//  Extensions.swift
//  BNLineGraph
//
//  Created by Botirjon Nasridinov on 13/01/23.
//

import Foundation

internal extension Array where Element == BNLineGraphPoint {
    func findBoundaryValues() -> BNLineGraphBoundaryValues {
        var minX: Float!
        var minY: Float!
        var maxX: Float!
        var maxY: Float!
        
        self.enumerated().forEach { index, point in
            if index == 0 {
                minX = point.independentVariable.value
                minY = point.dependentVariable.value
                maxX = point.independentVariable.value
                maxY = point.dependentVariable.value
            } else {
                let x = point.independentVariable.value
                let y = point.dependentVariable.value
                minX = Swift.min(x, minX)
                minY = Swift.min(y, minY)
                maxX = Swift.max(x, maxX)
                maxY = Swift.max(y, maxY)
            }
        }
        
        return .init(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}

internal extension Array where Element == BNSingleLineGraph {
    
    func findBoundaryValues() -> BNLineGraphBoundaryValues {
        var minX: Float!
        var minY: Float!
        var maxX: Float!
        var maxY: Float!
        
        self.enumerated().forEach { index, graph in
            let values = graph.values.findBoundaryValues()
            if index == 0 {
                minX = values.minX
                minY = values.minY
                maxX = values.maxX
                maxY = values.maxX
            } else {
                minX = Swift.min(minX, values.minX)
                minY = Swift.min(minY, values.minY)
                maxX = Swift.max(maxX, values.maxX)
                maxY = Swift.max(maxY, values.maxY)
            }
        }
        
        return .init(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
}


internal extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


internal extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}


internal extension String {
    func attributedString(adding attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString.init(string: self, attributes: attributes)
        return attributedString
    }
    
    func attributedString(adding attributes: [NSAttributedString.Key: Any], to substring: String) -> NSAttributedString {
        let range = NSString(string: self).range(of: substring)
        let attributedString = NSMutableAttributedString.init(string: self)
        attributedString.addAttributes(attributes, range: range)
        return attributedString
    }
}
