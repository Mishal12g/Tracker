//
//  ColorsCollectionView.swift
//  Tracker
//
//  Created by mihail on 24.01.2024.
//

import UIKit

final class ColorsCollectionView: UICollectionView {
    let delegateAndDataSource = HelperColorsCollectionView()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegateAndDataSource
        self.dataSource = delegateAndDataSource
        self.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identity)
        self.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
