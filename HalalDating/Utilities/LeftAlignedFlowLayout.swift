//
//  LeftAlignedFlowLayout.swift
//  HalalDating
//
//  Created by Apple on 28/11/24.
//

import Foundation

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var rows: [[UICollectionViewLayoutAttributes]] = []
        var currentRowY: CGFloat = -1
        
        // Group attributes by rows
        var currentRowAttributes: [UICollectionViewLayoutAttributes] = []
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y != currentRowY {
                if !currentRowAttributes.isEmpty {
                    rows.append(currentRowAttributes)
                }
                currentRowY = layoutAttribute.frame.origin.y
                currentRowAttributes = []
            }
            currentRowAttributes.append(layoutAttribute)
        }
        
        if !currentRowAttributes.isEmpty {
            rows.append(currentRowAttributes)
        }
        
        // Align each row's items to the left
        rows.forEach { row in
            var totalWidth: CGFloat = 0
            row.forEach { attribute in
                totalWidth += attribute.frame.width + minimumInteritemSpacing
            }
            totalWidth -= minimumInteritemSpacing  // Remove last spacing
            
            let leftInset = sectionInset.left
            var currentX = leftInset
            
            row.forEach { attribute in
                var frame = attribute.frame
                frame.origin.x = currentX
                attribute.frame = frame
                currentX += frame.width + minimumInteritemSpacing
            }
        }
        
        return attributes
    }
}
