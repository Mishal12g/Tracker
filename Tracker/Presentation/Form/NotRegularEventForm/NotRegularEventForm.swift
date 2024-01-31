import UIKit

protocol NotRegularEventFormViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, _ categoryName: String)
}

protocol NotRegularEventFormViewControllerProtocol: AnyObject {
    func isEnabled()
}

final class NotRegularEventFormViewController: UIViewController {
    //MARK: - public properties
    weak var delegate: HabitFormViewControllerDelegate?
    
    //MARK: - privates properties
    private var emoji: String?
    private var color: UIColor?
    private var category: TrackerCategory?
    
    private let dataSource: TwoButtonsDataSourceTableView = {
        let dataSource = TwoButtonsDataSourceTableView()
        dataSource.countButtons = 1
        
        return dataSource
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Новое нерегулярное событие"
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
    
    lazy private var textField: TextField = {
        let textField = TextField(placeholder: "Введите название трекера")
        textField.delegate = self
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    lazy private var categoryButton: UITableView = {
        let table = TableView(dataSource: dataSource)
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TwoButtonsCell")
        table.separatorStyle = .none
        
        return table
    }()
    
    lazy private var emojiCollection: EmojiCollectionView = {
        let collection = EmojiCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        collection.delegateAndDataSource.isEnabledDelegate = self
        
        return collection
    }()
    
    lazy private var colorsCollection: ColorsCollectionView = {
        let collection = ColorsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        collection.delegateAndDataSource.isEnabledDelegate = self
        
        return collection
    }()
    
    lazy private var cancelButton: Button = {
        let button = Button(type: .system)
        button.setStyle(borderColor: .ypRed, tintColor: .ypRed, borderWidth: 1, title: "Отменить")
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy private var doneButton: UIButton = {
        let button = Button(type: .system)
        button.setStyle(color: .ypGray1, tintColor: .white, title: "Создать")
        button.isEnabled = false
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
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        super.viewDidLoad()
        common()
    }
}

//MARK: - privates methods
private extension NotRegularEventFormViewController {
    func common() {
        view.backgroundColor = .white
        setupContraints()
        hideKeyBoard()
    }
       
    //MARK: action methods
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func hideKeyboard() {
        textField.resignFirstResponder()
        isEnabled()
    }
    
    @objc func didTapCreatedButton() {
        guard let text = textField.text,
              let color = color,
              let emoji = emoji,
              let category = category,
              !text.isEmpty
        else { return }
        let tracker = Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: nil)
        delegate?.createTracker(tracker, category.title)
        dismiss(animated: true)
    }
}

//MARK: - is enabled button
extension NotRegularEventFormViewController: HabitFormViewControllerProtocol {
    func isEnabled() {
        guard let text = textField.text,
              let _ = color,
              let _ = emoji,
              let _ = category,
              !text.isEmpty
        else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = .ypGray1
            return
        }
        
        doneButton.backgroundColor = .black
        doneButton.isEnabled = true
    }
}

//MARK: - TableView Delegate
extension NotRegularEventFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = CategoriesListViewController()
            vc.delegate = self
            vc.isEnabledDelegate = self
            present(vc, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - HelpersDelegate
extension NotRegularEventFormViewController: HelperColorsCollectionViewDelegate, HelperEmojiCollectionViewDelegate, CategoriesListViewControllerDelegate {
    func selectedCategory(_ category: TrackerCategory) {
        self.category = category
        dataSource.textOne = category.title
        categoryButton.reloadData()
    }
    
    func setEmoji(_ emoji: String) {
        self.emoji = emoji
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}

//MARK: - TextFieldDelegate
extension NotRegularEventFormViewController: UITextFieldDelegate {
    private func hideKeyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        isEnabled()
        
        return true
    }
}

//MARK: - setup constraints
private extension NotRegularEventFormViewController {
    func setupContraints() {
        //addSubviews
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        scrollView.addSubview(textField)
        scrollView.addSubview(categoryButton)
        scrollView.addSubview(emojiCollection)
        scrollView.addSubview(colorsCollection)
        scrollView.addSubview(stackH)
        stackH.addArrangedSubview(cancelButton)
        stackH.addArrangedSubview(doneButton)
        
        //constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            emojiCollection.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 32),
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
}
