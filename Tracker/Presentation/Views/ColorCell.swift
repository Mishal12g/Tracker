//
//  ColorCell.swift
//  Tracker
//
//  Created by mihail on 22.01.2024.
//

import UIKit

class ColorCell: UICollectionViewCell {
    static let identity = "ColorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
