import UIKit

final class StatisticViewController: UIViewController {
    let emptyImageView: UIImageView = {
        guard let image = UIImage(named: "il_error_2") else { return UIImageView() }
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistic.empty.state", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        navigationItem.title = NSLocalizedString("statistic.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        setConstraints()
    }
}

//MARK: - set constraints
private extension StatisticViewController {
    func setConstraints() {
        [emptyImageView,
         emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
