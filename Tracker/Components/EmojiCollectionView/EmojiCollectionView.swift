
import UIKit

protocol HelperEmojiCollectionViewDelegate: AnyObject {
    func setEmoji(_ emoji: String)
}

final class EmojiCollectionView: UICollectionView {
    //MARK: - public properties
    weak var setEmojidelegate: HelperEmojiCollectionViewDelegate?
    weak var isEnabledDelegate: HabitFormViewControllerProtocol?
    
    //MARK: - privates properties
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let params = GeometricParams(cellCount: 6, leftInset: 18.0, rightInset: 18.0, cellSpacing: 5.0)
    private var emojiStr = "" {
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
        self.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identity)
        self.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiCollectionView: DidEditEmojiCollection {
    func didChange(_ emoji: String) {
        emojiStr = emoji
        setEmojidelegate?.setEmoji(emoji)
    }
}

//MARK: - CollectionViewDataSource
extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identity, for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 16
        cell.config(text: emoji[indexPath.item])
        
        if emoji[indexPath.item] == emojiStr {
            cell.backgroundColor = .ypGray
        } else {
            cell.backgroundColor = .systemBackground
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        let text: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
            text = NSLocalizedString("collection.emoji", comment: "")
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
extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) as? EmojiCell else { return }
        
        cell.layer.cornerRadius = 16
        cell.backgroundColor = .ypGray
        emojiStr = emoji[indexPath.row]
        setEmojidelegate?.setEmoji(emoji[indexPath.item])
        isEnabledDelegate?.isEnabled()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
        cell.layer.cornerRadius = 16
        cell.backgroundColor = .systemBackground
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
