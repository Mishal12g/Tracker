import UIKit

final class TrackersViewController: UIViewController {
    //MARK: - privates properties
    private lazy var trackerStore = TrackerStore(delegate: self)
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var searchText: String = "" {
        didSet {
            applyFilter()
        }
    }
    
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private lazy var searchFiled: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Поиск"
        
        return search
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_Ru")
        picker.calendar.firstWeekday = 2
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identity)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerVCheader")
        
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
        
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        setupNavigationBar()
        addConstraint()
        applyFilter()
        hideErrorViews()
    }
    
    //filter
    func applyFilter() {
        trackerStore.filter(by: currentDate, and: searchText)
    }
    
    //tracker record
    func isTrackerCompletedToday(id: UUID) -> Bool {
        let res = completedTrackers.contains(where: { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        })
        
        return res
    }
    
    func isSameTracker(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDate = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDate
    }
    
    func completeTrackerDate(_ id: UUID) {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let selectedDate = calendar.startOfDay(for: currentDate)
        
        let components = calendar.dateComponents([.day], from: currentDate, to: selectedDate)
        
        if let days = components.day, days > 0 {
            return
        }
        
        let trackerRecord = TrackerRecord(id: id, date: currentDate)
        completedTrackers.append(trackerRecord)
        collectionView.reloadData()
    }
    
    //views setup
    func hideErrorViews() {
        emptyLabel.isHidden = trackerStore.numberOfSections != 0
        emptyImageView.isHidden = trackerStore.numberOfSections != 0
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
        currentDate = sender.date
        applyFilter()
    }
    
    @objc func addTrackerDidTap() {
        let trackerSelectionVC = CreatedTrackerViewController(delegate: self)
        
        self.present(trackerSelectionVC, animated: true)
    }
}

extension TrackersViewController: StoreDelegate {
    func didUpdate() {
        hideErrorViews()
        collectionView.reloadData()
    }
}

//MARK: - CreatedTrackerViewControllerDelegate
extension TrackersViewController: CreatedTrackerViewControllerDelegate {
    func didTapAddTrackerButton() {
        let vc = HabitFormViewController()
        vc.delegate = self
        vc.title = "Новая привычка"
        
        dismiss(animated: true)
        present(vc, animated: true)
    }
    
    func didTapAddNotRegularEvent() {
        let vc = NotRegularEventFormViewController()
        vc.delegate = self
        vc.title = "Новое нерегулярное событие"
        
        dismiss(animated: true)
        present(vc, animated: true)
    }
}

//MARK: - HabitFormViewControllerDelegate
extension TrackersViewController: HabitFormViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: TrackerCategory) {
        do {
            try trackerStore.addTracker(tracker: tracker, category: category)
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID) {
        completeTrackerDate(id)
    }
    
    func uncompleteTracker(id: UUID) {
        completedTrackers.removeAll(where: { trackerRecord in
            isSameTracker(trackerRecord: trackerRecord, id: id)
        })
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identity, for: indexPath) as? TrackerCell else { return UICollectionViewCell()}
        
        guard let tracker = trackerStore.object(at: indexPath) else {
            return cell
        }
        
        let isCompletedTracker = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        cell.config(with: tracker, isCompletedToday: isCompletedTracker, completedDays: completedDays)
        cell.delegate = self
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackerStore.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id: String
        let text: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "TrackerVCheader"
            text = trackerStore.header(at: indexPath) ?? ""
        case UICollectionView.elementKindSectionFooter:
            id = "footer"
            text = "Footer"
        default:
            id = ""
            text = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SupplementaryView, !trackerStore.isEmpty
        else { return UICollectionReusableView()}
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
        searchText = searchController.searchBar.text ?? ""
    }
}

//MARK: setup constraint
private extension TrackersViewController {
    func addSubViews() {
        [collectionView,
         emptyImageView,
         emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
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
            
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
