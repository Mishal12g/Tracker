//
//  ColorsCollectionView.swift
//  Tracker
//
//  Created by mihail on 24.01.2024.
//

import UIKit

protocol HelperColorsCollectionViewDelegate: AnyObject {
    func setColor(_ color: UIColor)
}

final class ColorsCollectionView: UICollectionView {
    //MARK: - public methods
    
    weak var delegateEdit: HelperColorsCollectionViewDelegate?
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: - privates methods
    private let colors: [UIColor] = [._1, ._2, ._3, ._4, ._5, ._6, ._7, ._8, ._9, ._10, ._11, ._12, ._13, ._14, ._15, ._16, ._17, ._18]
    private let params = GeometricParams(cellCount: 6, leftInset: 18.0, rightInset: 18.0, cellSpacing: 17.0)
    private var color = UIColor() {
        didSet {
            reloadData()
        }
    }
    
    
    //MARK: - overrides methods
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
        self.dataSource = self
        self.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identity)
        self.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorsCollectionView: DidEditColorCollection {
    func didChange(_ color: UIColor) {
        self.color = color
        self.delegateEdit?.setColor(color)
    }
}

//MARK: - CollectionViewDataSource
extension ColorsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identity, for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 8
        cell.backgroundColor = colors[indexPath.item]
        
        if colors[indexPath.item] == color {
            cell.updateSelectedView(false)
            cell.setColor(colors[indexPath.row])
            delegateEdit?.setColor(color)
            isEnabledDelegate?.isEnabled()
        } else {
            cell.updateSelectedView(true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        let text: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
            text = NSLocalizedString("collection.color", comment: "")
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
            text = "Footer"
        default:
            id = ""
            text = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView else { return UICollectionReusableView()}
        view.titleLabel.text = text
        return view
    }
}

//MARK: - CollectionViewDelegate
extension ColorsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
        cell.updateSelectedView(false)
        cell.setColor(colors[indexPath.row])
        delegateEdit?.setColor(colors[indexPath.row])
        isEnabledDelegate?.isEnabled()
        color = colors[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else { return }
        cell.updateSelectedView(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - params.paddingWidth) / CGFloat(params.cellCount)
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 16, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
}
