
import UIKit

final class EmojiCollectionView: UICollectionView {
    //MARK: - public properties
    let delegateAndDataSource = HelperEmojiCollectionView()
    
    //MARK: - overrides methods
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegateAndDataSource
        self.dataSource = delegateAndDataSource
        self.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identity)
        self.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
