import UIKit

final class TrackersViewController: UIViewController {
    //MARK: - privates properties
    private lazy var trackerStore = TrackerStore(delegate: self)
    
    private var currentDate: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from:  datePicker.date)
        
        guard let date = calendar.date(from: dateComponents) else { return Date()}
        
        return date
    }
    
    private var searchText: String = "" {
        didSet {
            applyFilter()
        }
    }
    
    private let recordStore = TrackerRecordStore()
    private let params = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
    
    private lazy var searchFiled: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        search.searchBar.placeholder = NSLocalizedString("trackers.searchTextFieldPlaceholder", comment: "")
        
        return search
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale.current
        picker.calendar.firstWeekday = 2
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .ypBackground
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identity)
        collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrackerVCheader")
        
        return collection
    }()
    
    private lazy var addTrackerButton: UIBarButtonItem = {
      let item = UIBarButtonItem(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)
            ),
            style: .plain,
            target: self,
            action: #selector(addTrackerDidTap)
        )
        
        item.tintColor = .label
        
        return item
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
        label.text = NSLocalizedString("trackers.emptyPlaceholderView", comment: "")
        
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
        view.backgroundColor = .ypBackground
        setupNavigationBar()
        addConstraint()
        applyFilter()
        hideErrorViews()
    }
    
    //filter
    func applyFilter() {
        trackerStore.filter(by: currentDate, and: searchText)
    }
    
    //views setup
    func hideErrorViews() {
        emptyLabel.isHidden = trackerStore.numberOfSections != 0
        emptyImageView.isHidden = trackerStore.numberOfSections != 0
    }
    
    func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("trackers.title", comment: "")
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchFiled
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func makeContextMenu(by indexPath: IndexPath) -> UIMenu? {
        guard 
            let trackerCell = collectionView.cellForItem(at: indexPath) as? TrackerCell,
            let tracker = self.trackerStore.object(at: indexPath)
        else { return nil }
        
        let titlePinnedAction = tracker.isPinned ? NSLocalizedString("context.menu.unpin", comment: "") :
            NSLocalizedString("context.menu.pinned", comment: "")
        
        let deleteAction = UIAction(title: NSLocalizedString("context.menu.delete", comment: ""), attributes: .destructive) { _ in
            
            let deleteAction = UIAlertAction(title: NSLocalizedString("alert.delete.tracker", comment: ""), style: .destructive) { _ in
                self.trackerStore.deleteTracker(trackerID: trackerCell.trackerID)
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert.delete.cancel.tracker", comment: ""), style: .cancel)
            
            let alert = UIAlertController(title: NSLocalizedString("alert.delete.message.tracker", comment: ""), message: nil, preferredStyle: .actionSheet)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        
        let pinnedAction = UIAction(title: titlePinnedAction) { _ in
            guard let id = trackerCell.trackerID else { return }
            
            self.trackerStore.pinnedTracker(trackerID: id, shouldPin: !tracker.isPinned)
        }
        
        let editAction = UIAction(title: NSLocalizedString("context.menu.edit", comment: "")) { _ in
            let editForm = EditHabitFormViewController()
            editForm.delegate = self
            editForm.trackerID = trackerCell.trackerID
            editForm.getIndexPath(indexPath)

            self.present(editForm, animated: true)
        }
        
        return UIMenu(children: [pinnedAction, editAction, deleteAction])
    }
    
    //MARK: action methods
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
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
                
        dismiss(animated: true)
        present(vc, animated: true)
    }
    
    func didTapAddNotRegularEvent() {
        let vc = NotRegularEventFormViewController()
        vc.delegate = self
        
        dismiss(animated: true)
        present(vc, animated: true)
    }
}

extension TrackersViewController: EditHabitFormViewControllerDelegate {
    func didUpdateTracjer(_ tracker: Tracker, _ category: TrackerCategory, _ trackerID: UUID) {
            trackerStore.updateTracker(tracker: tracker, category: category, trackerID: trackerID)
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
        
        if currentDate < Date() {
            let record = TrackerRecord(trackerId: id, completedDate: currentDate)
            recordStore.add(record)
            collectionView.reloadData()
        }
    }
    
    func uncompleteTracker(id: UUID) {
        if let record = recordStore.fetchRecord(by: id, and: currentDate) {
            recordStore.delete(record)
            collectionView.reloadData()
        }
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
        
        let isCompletedTracker = recordStore.isTrackerCompletedToday(by: tracker.id, and: currentDate)
        let completedDays = recordStore.completedTrackers(by: tracker.id)

        cell.delegate = self
        cell.config(
            with: tracker,
            isCompletedToday: isCompletedTracker,
            completedDays: completedDays
        )
        
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { _ in
            self.makeContextMenu(by: indexPath)
        }
    }
    
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

//MARK: - serach delegate
extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}

//MARK: - setup constraint
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
