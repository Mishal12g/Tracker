import UIKit

class TrackersViewController: UIViewController {
    //MARK: - privates properties
    private var categories: [TrackerCategory] = [TrackerCategory(title: "Покушать", trackers: [
        Tracker(id: UUID(),
                name: "Мясo",
                color: ._1,
                emoji: "🙂",
                schedule: []),
        Tracker(id: UUID(),
                name: "Суп",
                color: ._2,
                emoji: "🎸",
                schedule: []),
        Tracker(id: UUID(),
                name: "Гречку",
                color: ._3,
                emoji: "😭",
                schedule: []),
        Tracker(id: UUID(),
                name: "Окрошку",
                color: ._4,
                emoji: "🍔",
                schedule: [])]),
                                                 TrackerCategory(title: "Побегать", trackers: [
                                                    Tracker(id: UUID(),
                                                            name: "Мясo",
                                                            color: ._1,
                                                            emoji: "🙂",
                                                            schedule: []),
                                                    Tracker(id: UUID(),
                                                            name: "Суп",
                                                            color: ._2,
                                                            emoji: "🎸",
                                                            schedule: []),]),
                                                 
                                                 TrackerCategory(title: "прыжок", trackers: [
                                                    Tracker(id: UUID(),
                                                            name: "Мясo",
                                                            color: ._1,
                                                            emoji: "🙂",
                                                            schedule: []),
                                                    Tracker(id: UUID(),
                                                            name: "Окрошку",
                                                            color: ._4,
                                                            emoji: "🍔",
                                                            schedule: [])]),
    ]
    private var completedTrackers: [TrackerRecord] = []
    private let datePicker = UIDatePicker()
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    private let addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "YP_add")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        
        return button
    }()
    
    private let emptyImageView: UIImageView = {
        let image = UIImage(named: "il_error_1")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        
        return label
    }()
    
    //MARK: - Overrides methods
    override func viewDidLoad() {
        view.backgroundColor = .white
        hideErrorViews()
        setupNavigationBar()
        addSubViews()
        addConstraint()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identity)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerVCheader")
    }
}

//MARK: - For methods view
private extension TrackersViewController {
    
    func hideErrorViews() {
        guard !categories.isEmpty else {
            hide(false)
            return
        }
        
        hide(true)
        
        func hide(_ isHide: Bool) {
            emptyLabel.isHidden = isHide
            emptyImageView.isHidden = isHide
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print(formattedDate)
    }
    
    @objc func addTrackerDidTap() {
        let trackerSelectionVC = CreatedTrackerViewController(delegate: self)
        trackerSelectionVC.title = "Создание трекера"
        let vc = UINavigationController(rootViewController: trackerSelectionVC)
        
        self.present(vc, animated: true)
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Трекеры"
        addTrackerButton.addTarget(self, action: #selector(addTrackerDidTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func addSubViews() {
        
        view.addSubview(collectionView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyImageView.centerXAnchor),
        ])
    }
}

//MARK: - CreadtedTrackerViewControllerDelegate
extension TrackersViewController: CreatedTrackerViewControllerDelegate {
    func didTapAddButton() {
        let vc = HabitFormViewController()
        vc.delegate = self
        vc.title = "Новая привычка"
        
        present(vc, animated: true)
    }
}

//MARK: - HabitFormViewControllerDelegate
extension TrackersViewController: HabitFormViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ categoryName: String) {
        if let i = categories.firstIndex(where: {
            $0.title == categoryName
        }) {
            categories[i].trackers.append(tracker)
        }
        
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identity, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        let category = categories[indexPath.section]
        let tracker = category.trackers[indexPath.item]
        
        cell.emojiLabel.text = tracker.emoji
        cell.trackerNameLabel.text = tracker.name
        cell.view.backgroundColor = tracker.color
        cell.addButton.tintColor = tracker.color
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        let text: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "TrackerVCheader"
            text = categories[indexPath.section].title
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

//MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}
