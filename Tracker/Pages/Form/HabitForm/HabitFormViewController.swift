import UIKit

protocol HabitFormViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, _ category: TrackerCategory)
}

protocol HabitFormViewControllerProtocol: AnyObject {
    func isEnabled()
}

final class HabitFormViewController: UIViewController {
    //MARK: - public properties
    weak var delegate: HabitFormViewControllerDelegate?
    
    //MARK: - privates properties
    private var emoji: String?
    private var color: UIColor?
    private var category: TrackerCategory?
    private var schedule: Array<Weekday>?
    
    private let dataSource = TwoButtonsDataSourceTableView()
    
    private let titleLabel: UILabel = {
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
    
    private lazy var textField: TextField = {
        let textField = TextField(placeholder: "Введите название трекера")
        textField.delegate = self
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    private lazy var twoButtonsVertical: UITableView = {
        let table = TableView(dataSource: dataSource)
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TwoButtonsCell")
        
        return table
    }()
    
    private lazy var emojiCollection: EmojiCollectionView = {
        let collection = EmojiCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        collection.delegateAndDataSource.isEnabledDelegate = self
        
        return collection
    }()
    
    private lazy var colorsCollection: ColorsCollectionView = {
        let collection = ColorsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateAndDataSource.delegate = self
        collection.delegateAndDataSource.isEnabledDelegate = self
        
        return collection
    }()
    
    private lazy var cancelButton: Button = {
        let button = Button(type: .system)
        button.setStyle(borderColor: .ypRed, tintColor: .ypRed, borderWidth: 1, title: "Отменить")
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = Button(type: .system)
        button.setStyle(color: .ypGray1, tintColor: .white, title: "Создать")
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapCreatedButton), for: .touchUpInside)
        
        return button
    }()
    
    private let stackH: UIStackView = {
        let stack = UIStackView()
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
private extension HabitFormViewController {
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
              let schedule = schedule,
              !text.isEmpty
        else { return }
        let tracker = Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: schedule)
        delegate?.createTracker(tracker, category)
        dismiss(animated: true)
    }
}

//MARK: - is enabled button
extension HabitFormViewController: HabitFormViewControllerProtocol {
    func isEnabled() {
        guard let text = textField.text,
              let _ = color,
              let _ = emoji,
              let _ = category,
              let _ = schedule,
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
extension HabitFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = CategoriesListViewController()
            vc.delegate = self
            vc.isEnabledDelegate = self
            present(vc, animated: true)
        } else if indexPath.item == 1 {
            let vc = ScheduleViewController()
            vc.delegate = self
            vc.isEnabledDelegate = self
            present(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
}

//MARK: - HelpersDelegate
extension HabitFormViewController: HelperColorsCollectionViewDelegate, HelperEmojiCollectionViewDelegate, CategoriesListViewControllerDelegate, ScheduleViewControllerDelegate {
    func setSchedule(_ weekdays: Set<Weekday>) {
        var selectedDays: String?
        schedule = Array(weekdays)
        
        if let schedule = schedule, !schedule.isEmpty {
            selectedDays = schedule.count == 7 ? "Каждый день" : schedule
                .sorted { $0.rawValue < $1.rawValue }
                .map { $0.short }
                .joined(separator: ", ")
            
            self.schedule = schedule
                .sorted { $0.rawValue < $1.rawValue }
                .map { $0 }
        } else { return }
        
        dataSource.textTwo = selectedDays
        twoButtonsVertical.reloadData()
    }
    
    func selectedCategory(_ category: TrackerCategory) {
        self.category = category
        dataSource.textOne = category.title
        twoButtonsVertical.reloadData()
    }
    
    func setEmoji(_ emoji: String) {
        self.emoji = emoji
    }
    
    func setColor(_ color: UIColor) {
        self.color = color
    }
}

//MARK: - TextFieldDelegate
extension HabitFormViewController: UITextFieldDelegate {
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
private extension HabitFormViewController {
    func setupContraints() {
        //addSubviews
        [scrollView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [textField,
         twoButtonsVertical,
         emojiCollection,
         colorsCollection,
         stackH].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        [cancelButton, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackH.addArrangedSubview($0)
        }
        
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
}
