import UIKit

protocol HabitFormViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ categoryName: String)
}

final class HabitFormViewController: UIViewController {
    var delegate: HabitFormViewControllerDelegate?
    var emoji: String?
    var color: UIColor?
    let category = "прыжок"
    private let dataSource = TwoButtonsDataSourceTableView()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    private let textField = TextField(placeholder: "Введите название трекера")
    
    lazy private var twoButtonsVertical: UITableView = {
        let table = TableView(dataSource: dataSource)
        
        return table
    }()
    
    lazy private var emojiCollection: EmojiCollectionView = {
        let collection = EmojiCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        
        return collection
    }()
    
    lazy private var colorsCollection: ColorsCollectionView = {
        let collection = ColorsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        
        return collection
    }()
    
    private let cancelButton: Button = {
        let button = Button(type: .system)
        button.setStyle(borderColor: .ypRed, tintColor: .ypRed, borderWidth: 1, title: "Отменить")
        
        return button
    }()
    
    lazy private var doneButton: UIButton = {
        let button = Button(type: .system)
        button.setStyle(color: .ypGray1, tintColor: .white, title: "Создать")
        button.addTarget(self, action: #selector(didTapCreatedButton), for: .touchUpInside)
        
        return button
    }()
    
    private let stackH: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twoButtonsVertical.delegate = self
        twoButtonsVertical.register(UITableViewCell.self, forCellReuseIdentifier: "TwoButtonsCell")
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(label)
        scrollView.addSubview(textField)
        scrollView.addSubview(twoButtonsVertical)
        scrollView.addSubview(emojiCollection)
        scrollView.addSubview(colorsCollection)
        scrollView.addSubview(stackH)
        stackH.addArrangedSubview(cancelButton)
        stackH.addArrangedSubview(doneButton)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            label.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            scrollView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            twoButtonsVertical.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            twoButtonsVertical.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            twoButtonsVertical.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            twoButtonsVertical.heightAnchor.constraint(equalToConstant: 150),
            
            emojiCollection.topAnchor.constraint(equalTo: twoButtonsVertical.bottomAnchor, constant: 32),
            emojiCollection.heightAnchor.constraint(equalToConstant: 250),
            emojiCollection.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            colorsCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor),
            colorsCollection.heightAnchor.constraint(equalToConstant: 250),
            colorsCollection.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            stackH.topAnchor.constraint(equalTo: colorsCollection.bottomAnchor, constant: 10),
            stackH.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            stackH.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            stackH.heightAnchor.constraint(equalToConstant: 60),
            stackH.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    @objc func didTapCreatedButton() {
        guard let text = textField.text,
              let color = color,
              let emoji = emoji
        else { return }
        let tracker = Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: [])
        delegate?.createTracker(tracker, category)
        dismiss(animated: true)
    }
}

//MARK: - TableView Delegate
extension HabitFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - HelpersDelegate
extension HabitFormViewController: HelperColorsCollectionViewDelegate, HelperEmojiCollectionViewDelegate {
    func setEmoji(_ emoji: String) {
        self.emoji = emoji
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}
