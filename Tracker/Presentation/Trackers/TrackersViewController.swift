import UIKit

class TrackersViewController: UIViewController {
    //MARK: - privates properties
    private var categories = CategoriesStorageService.shared.categories
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var categoriesListObserver: NSObjectProtocol?
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    lazy private var searchFiled: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        
        return search
    }()
    
    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale.current
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
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
    
    //MARK: - overrides methods
    override func viewDidLoad() {
        common()
    }
}

//MARK: - privates methods
private extension TrackersViewController {
    func common() {
        view.backgroundColor = .white
        hideErrorViews()
        setupNavigationBar()
        addConstraint()
        setupCollection()
        addCategoriesObserver()
    }
    func filterCategoriesByDate() {
        let dayOfWeek = Calendar.current.component(.weekday, from: datePicker.date)
        
        var filteredCategories = [TrackerCategory]()
        
        categories.forEach { category in
            var filteredTrackers: [Tracker] = []
            
            category.trackers.forEach { tracker in
                let isTrackerAvailableOnSelectedDay = tracker.schedule.contains(Weekday(rawValue: dayOfWeek)!)
                
                if isTrackerAvailableOnSelectedDay {
                    filteredTrackers.append(tracker)
                }
            }
            
            if !filteredTrackers.isEmpty {
                var filteredCategory = category
                filteredCategory.trackers = filteredTrackers
                filteredCategories.append(filteredCategory)
            }
        }
        
        self.filteredCategories = filteredCategories
        hideErrorViews()
        collectionView.reloadData()
    }
    
    func filterCategoriesByTrackers(searchText: String?) {
        var filteredCategories = [TrackerCategory]()
        
        if !searchText!.isEmpty {
            categories.forEach { category in
                let trackers = category.trackers.filter {
                    $0.name.lowercased().hasPrefix(searchText!.lowercased())
                }
                
                if !trackers.isEmpty {
                    var filtteredCategory = category
                    filtteredCategory.trackers = trackers
                    filteredCategories.append(filtteredCategory)
                }
            }
            
            self.filteredCategories = filteredCategories
            hideErrorViews()
            collectionView.reloadData()
        } else {
            filterCategoriesByDate()
        }
    }
    
    func addCategoriesObserver() {
        categoriesListObserver = NotificationCenter.default.addObserver(forName: CategoriesStorageService.didChangeNotification,
                                                                        object: nil,
                                                                        queue: .main) { [weak self]_ in
            guard let self = self else { return }
            self.updatesCollectionView()
        }
    }
    
    func updatesCollectionView() {
        self.categories = CategoriesStorageService.shared.categories
        filterCategoriesByDate()
    }
    
    func setupCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identity)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerVCheader")
    }
    
    func hideErrorViews() {
        guard !filteredCategories.isEmpty else {
            hide(false)
            return
        }
        
        let categoriesIsNotEmpty = filteredCategories.filter { !$0.trackers.isEmpty }
        
        if categoriesIsNotEmpty.isEmpty {
            hide(false)
        } else {
            hide(true)
        }
        
        func hide(_ isHide: Bool) {
            emptyLabel.isHidden = isHide
            emptyImageView.isHidden = isHide
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Трекеры"
        addTrackerButton.addTarget(self, action: #selector(addTrackerDidTap), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchFiled
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK: action methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        filterCategoriesByDate()
    }
    
    @objc func addTrackerDidTap() {
        let trackerSelectionVC = CreatedTrackerViewController(delegate: self)
        trackerSelectionVC.title = "Создание трекера"
        let vc = UINavigationController(rootViewController: trackerSelectionVC)
        
        self.present(vc, animated: true)
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
        CategoriesStorageService.shared.addTracker(categoryName, tracker)
        hideErrorViews()
    }
}

//MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func didTapAddButton(_ cell: TrackerCell) {
        let record = TrackerRecord(id: cell.id, date: datePicker.date)
        if cell.isDoneTracker {
            completedTrackers.append(record)
        } else {
            guard let index = completedTrackers.firstIndex(where: { $0.id == cell.id }) else { return }
            completedTrackers.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identity, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        let category = filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]
        
        cell.delegate = self
        cell.emojiLabel.text = tracker.emoji
        cell.trackerNameLabel.text = tracker.name
        cell.view.backgroundColor = tracker.color
        cell.addButton.tintColor = tracker.color
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        let text: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "TrackerVCheader"
            text = filteredCategories[indexPath.section].title
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
            text = "Footer"
        default:
            id = ""
            text = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView, !filteredCategories[indexPath.section].trackers.isEmpty else { return UICollectionReusableView()}
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

//MARK: serach delegate
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterCategoriesByTrackers(searchText: searchController.searchBar.text)
    }
}

//MARK: setup constraint
private extension TrackersViewController {
    func addSubViews() {
        view.addSubview(collectionView)
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
    }
    
    func addConstraint() {
        addSubViews()
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
