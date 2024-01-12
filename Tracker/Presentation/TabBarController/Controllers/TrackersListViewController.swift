import UIKit

class TrackersListViewController: UIViewController {
    let addTrackerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "add")
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleToFill
        
        return button
    }()

    let dateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("12.12.02", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 8
        let titleInset = UIEdgeInsets(top: 6, left: 5.5, bottom: 6, right: 5.5)
        button.titleEdgeInsets = titleInset
        
        return button
    }()
    
    let imageView: UIImageView = {
        let image = UIImage(named: "il_error_1")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "Что будем отслеживать?"
        
        return label
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupNavigationBar()
        addSubViews()
        addConstraint()
    }
}

//MARK: - For methods
private extension TrackersListViewController {
    func setupNavigationBar() {
        navigationItem.title = "Трекеры"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func addSubViews() {
        view.addSubview(imageView)
        view.addSubview(emptyLabel)
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            dateButton.widthAnchor.constraint(equalToConstant: 100),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            emptyLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        ])
    }
}
