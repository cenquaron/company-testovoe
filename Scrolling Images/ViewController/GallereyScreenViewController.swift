
import UIKit

class GallereyScreenViewController: UIViewController {
    
    lazy var galleryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "View Your Gallery"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .customC
        return label
    }()
    
    private lazy var oceanImageStack: UIStackView = {
        return getImageStackView(target: "ocean", placeholder: "Ocean")
    }()

    private lazy var forestImageStack: UIStackView = {
        return getImageStackView(target: "forest", placeholder: "Forest")
    }()

    private lazy var codingImageStack: UIStackView = {
        return getImageStackView(target: "programming", placeholder: "Programming")
    }()

    private lazy var studyImageStack: UIStackView = {
        return getImageStackView(target: "study", placeholder: "Study")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setGalleryLabel()
        setOceanImageView()
        setForestImageView()
        setCodingImageView()
        setStudyImageView()
    }
}

extension GallereyScreenViewController {
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if let tappedStack = sender.view as? UIStackView {
            let target = tappedStack.accessibilityLabel
            let secondViewController = CollectiovViewImageViewController(target: target!)
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    private func setGalleryLabel() {
        view.addSubview(galleryLabel)
        
        NSLayoutConstraint.activate([
            galleryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            galleryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
    }
    
    private func setOceanImageView() {
        view.addSubview(oceanImageStack)
        
        NSLayoutConstraint.activate([
            oceanImageStack.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor, constant: 20),
            oceanImageStack.leadingAnchor.constraint(equalTo: galleryLabel.leadingAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        oceanImageStack.addGestureRecognizer(tapGesture)
        oceanImageStack.isUserInteractionEnabled = true
    }
    
    private func setForestImageView() {
        view.addSubview(forestImageStack)
        
        NSLayoutConstraint.activate([
            forestImageStack.topAnchor.constraint(equalTo: galleryLabel.bottomAnchor, constant: 20),
            forestImageStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        forestImageStack.addGestureRecognizer(tapGesture)
        forestImageStack.isUserInteractionEnabled = true
        
    }
    
    private func setCodingImageView() {
        view.addSubview(codingImageStack)
        
        NSLayoutConstraint.activate([
            codingImageStack.topAnchor.constraint(equalTo: oceanImageStack.bottomAnchor, constant: 20),
            codingImageStack.leadingAnchor.constraint(equalTo: galleryLabel.leadingAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        codingImageStack.addGestureRecognizer(tapGesture)
        codingImageStack.isUserInteractionEnabled = true
    }
    
    private func setStudyImageView() {
        view.addSubview(studyImageStack)
        
        NSLayoutConstraint.activate([
            studyImageStack.topAnchor.constraint(equalTo: forestImageStack.bottomAnchor, constant: 20),
            studyImageStack.trailingAnchor.constraint(equalTo: forestImageStack.trailingAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        studyImageStack.addGestureRecognizer(tapGesture)
        studyImageStack.isUserInteractionEnabled = true
        
    }
}

extension GallereyScreenViewController {
    
    func getImageStackView(target: String, placeholder: String) -> UIStackView {
        
        lazy var placeholderText: UIView = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.text = placeholder
            text.font = .systemFont(ofSize: 14)
            text.textColor = .customC
            
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(text)
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 19).isActive = true
            return view
        }()
        
        lazy var tapImageView: UIImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            view.translatesAutoresizingMaskIntoConstraints = false
            view.image = UIImage(named: target)
            view.contentMode = .scaleAspectFit
            view.backgroundColor = .systemBackground
            view.layer.cornerRadius = 9
            view.layer.masksToBounds = true
            view.widthAnchor.constraint(equalToConstant: 160).isActive = true
            view.heightAnchor.constraint(equalToConstant: 160).isActive = true

            return view
        }()
        
        lazy var hStack: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 5
            stack.addArrangedSubview(tapImageView)
            stack.addArrangedSubview(placeholderText)

            return stack
        }()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        hStack.addGestureRecognizer(tapGesture)
        hStack.isUserInteractionEnabled = true
        hStack.accessibilityLabel = target

        return hStack
    }
}
