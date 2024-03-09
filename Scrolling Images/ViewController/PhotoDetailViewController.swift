import UIKit

class PhotoDetailViewController: UIViewController {
    
    let result: Result
    
    init(result: Result) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollImageView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 9
        imageView.alpha = 0
        
        return imageView
    }()
    
    private lazy var idUILabel = infoUILabel
    
    private lazy var dateCrealeUILabel = infoUILabel
    
    private lazy var descriptionUILabel = infoUILabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Detail"
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1
        }
        
        setupInfoUILabel()
        setConstrainScrollImageView()
        setConstrainImageView()
        setInfoIdLabelConstrain()
        setInfoDateCrealeUILabel()
        setInfoDescriptionUILabel()
        
        view.backgroundColor = .systemBackground
        
        // Загрузка изображения в полном размере
        if let url = URL(string: result.urls.regular) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                    self?.setZoomScale()
                }
            }.resume()
        }
    }
    
    @objc func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [result.urls.full], applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = navigationItem.rightBarButtonItem
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func setZoomScale() {
        let widthScale = scrollImageView.frame.size.width / imageView.image!.size.width
        let heightScale = scrollImageView.frame.size.height / imageView.image!.size.height
        let minScale = min(widthScale, heightScale)
        
        scrollImageView.minimumZoomScale = minScale
        scrollImageView.zoomScale = minScale
    }
}

extension PhotoDetailViewController {
    
    private func setConstrainScrollImageView() {
        view.addSubview(scrollImageView)
        
        NSLayoutConstraint.activate([
            scrollImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setConstrainImageView() {
        scrollImageView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollImageView.topAnchor, constant: 60),
            imageView.leadingAnchor.constraint(equalTo: scrollImageView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: scrollImageView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: scrollImageView.bottomAnchor)
        ])
    }
    
    
    private func setInfoIdLabelConstrain() {
        view.addSubview(idUILabel)
        idUILabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            idUILabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            idUILabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
    
    private func setInfoDateCrealeUILabel() {
        view.addSubview(dateCrealeUILabel)
        dateCrealeUILabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateCrealeUILabel.topAnchor.constraint(equalTo: idUILabel.bottomAnchor, constant: 20),
            dateCrealeUILabel.leadingAnchor.constraint(equalTo: idUILabel.leadingAnchor)
        ])
    }
    
    private func setInfoDescriptionUILabel() {
        view.addSubview(descriptionUILabel)
        descriptionUILabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionUILabel.topAnchor.constraint(equalTo: dateCrealeUILabel.bottomAnchor, constant: 20),
            descriptionUILabel.leadingAnchor.constraint(equalTo: dateCrealeUILabel.leadingAnchor),
            descriptionUILabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupInfoUILabel() {
        idUILabel.text = "ID: \(result.id)"
        dateCrealeUILabel.text = "Created at: \(result.created_at)"
        descriptionUILabel.text = "Description: \(result.description ?? "")"
        descriptionUILabel.numberOfLines = 0
        descriptionUILabel.lineBreakMode = .byWordWrapping
    }
}

extension PhotoDetailViewController {
    private var infoUILabel: UILabel {
        let label = UILabel()
        label.textColor = .customC
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
