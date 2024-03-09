import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 9
        image.alpha = 0
        return image
    }()
    
    let padding: CGFloat = 5.0
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(x: padding, y: padding, width: contentView.bounds.width - 2 * padding, height: contentView.bounds.height - 2 * padding)
        
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        setImageActivityIndicator()
    }
    
    func configurate(with urlString: String) {
        activityIndicator.startAnimating()

        guard let url = URL(string: urlString) else { return }

        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.imageView.image = cachedImage
            activityIndicator.stopAnimating()
        } else {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                
                // cохранить изображение в кеш
                if let image = UIImage(data: data) {
                    self?.imageCache.setObject(image, forKey: urlString as NSString)
                }
                
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }.resume()
        }
    }
}


extension ImageCollectionViewCell {
    
    private func setImageActivityIndicator() {
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
