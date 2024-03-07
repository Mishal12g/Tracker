import UIKit

protocol EditHabitFormViewControllerDelegate: AnyObject {
    func didUpdateTracjer(_ tracker: Tracker, _ category: TrackerCategory, _ trackerID: UUID)
}

protocol DidEditEmojiCollection: AnyObject {
    func didChange(_ emoji: String)
}

protocol DidEditColorCollection: AnyObject {
    func didChange(_ color: UIColor)
}

final class EditHabitFormViewController: UIViewController {
    //MARK: - public properties
    weak var delegate: EditHabitFormViewControllerDelegate?
    weak var editEmojiDelegate: DidEditEmojiCollection?
    weak var editColorDelegate: DidEditColorCollection?
    var trackerID: UUID?
    
    //MARK: - privates properties
    private var selectedTracker: Tracker?
    private var emoji: String?
    private var color: UIColor?
    private var category: TrackerCategory?
    private var schedule: Array<Weekday>?
    private var indexPath: IndexPath?
    
    private let storeRecord = TrackerRecordStore()
    private let trackerStore = TrackerStore()
    private let viewModel = CategoryViewModel()
    private let dataSource = TwoButtonsDataSourceTableView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("edit.form.title", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("edit.form", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    private lazy var textField: TextField = {
        let textField = TextField(placeholder: NSLocalizedString("habit.form.textfield.placeholder", comment: ""))
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
        collection.setEmojidelegate = self
        collection.isEnabledDelegate = self
        self.editEmojiDelegate = collection
        
        return collection
    }()
    
    private lazy var colorsCollection: ColorsCollectionView = {
        let collection = ColorsCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegateEdit = self
        collection.isEnabledDelegate = self
        self.editColorDelegate = collection
        
        return collection
    }()
    
    private lazy var cancelButton: Button = {
        let button = Button(type: .system)
        button.setStyle(color: .ypBackground, borderColor: .ypRed, tintColor: .ypRed, borderWidth: 1, title: NSLocalizedString("edit.form.cancel.button", comment: ""))
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = Button(type: .system)
        button.setStyle(color: .ypGray1, tintColor: .white, title: NSLocalizedString("edit.form.save.button", comment: ""))
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTapUpdateButton), for: .touchUpInside)
        
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
    
    func getIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}

//MARK: - privates methods
private extension EditHabitFormViewController {
    func common() {
        view.backgroundColor = .ypBackground
        setupContraints()
        hideKeyBoard()
        daysCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString(
                "numberOfDays",
                comment: "Number of remaining days"),
            storeRecord.completedTrackers(by: trackerID ?? UUID())
        )
        
        viewModel.categorySelectedBinding = { [weak self] category in
            guard let self = self else { return }
            self.category = category
            self.dataSource.textOne = category.title
            self.twoButtonsVertical.reloadData()
        }
        
        guard
            let trackerID = trackerID,
            let tracker = trackerStore.getTracker(id: trackerID),
            let schedule = tracker.schedule,
            let category = trackerStore.category(id: tracker.id)
        else { return }
        
        self.category = category
        
        textField.text = tracker.name
        dataSource.textOne = category.title
        dataSource.textTwo = setSchedule(schedule: schedule)
        editEmojiDelegate?.didChange(tracker.emoji)
        editColorDelegate?.didChange(tracker.color)
    }
    
    func setSchedule(schedule: Array<Weekday>) -> String {
        var selectedDays: String = ""
        
        if !schedule.isEmpty {
            selectedDays = schedule.count == 7 ? NSLocalizedString("every.day", comment: "") : schedule
                .sorted { $0.rawValue < $1.rawValue }
                .map { $0.short }
                .joined(separator: ", ")
            
            self.schedule = schedule
                .sorted { $0.rawValue < $1.rawValue }
                .map { $0 }
            
            return selectedDays
        } else { return "" }
    }
    
    //MARK: action methods
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc func hideKeyboard() {
        textField.resignFirstResponder()
        isEnabled()
    }
    
    @objc func didTapUpdateButton() {
        guard let text = textField.text,
              let color = color,
              let emoji = emoji,
              let category = category,
              let schedule = schedule,
              let trackerID = trackerID,
              !text.isEmpty
        else { return }
        
        let tracker = Tracker(
            id: UUID(),
            name: text,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isPinned: false
        )
        delegate?.didUpdateTracjer(tracker, category, trackerID)
        dismiss(animated: true)
    }
}

//MARK: - is enabled button
extension EditHabitFormViewController: HabitFormViewControllerProtocol {
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
            doneButton.tintColor = .white
            return
        }
        
        doneButton.backgroundColor = .label
        doneButton.tintColor = .systemBackground
        doneButton.isEnabled = true
    }
}

//MARK: - TableView Delegate
extension EditHabitFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let vc = CategoriesListViewController(viewModel: viewModel)
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
extension EditHabitFormViewController: HelperColorsCollectionViewDelegate, HelperEmojiCollectionViewDelegate, ScheduleViewControllerDelegate {
    func setSchedule(_ weekdays: Set<Weekday>) {
        
        schedule = Array(weekdays)
        
        guard
            let schedule = schedule
        else { return }
        
        dataSource.textTwo = setSchedule(schedule: schedule)
        
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
extension EditHabitFormViewController: UITextFieldDelegate {
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
private extension EditHabitFormViewController {
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
         stackH,
         daysCountLabel].forEach {
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
            
            daysCountLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            daysCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textField.topAnchor.constraint(equalTo: daysCountLabel.bottomAnchor, constant: 40),
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
