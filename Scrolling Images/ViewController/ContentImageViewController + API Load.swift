import UIKit

class CollectiovViewImageViewController: UIViewController {
    
    let find = "offline"
        
    let target: String
    
    var currentPage = 1
    var isLoading = false
    
    init(target: String) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    var results: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        fetchPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func fetchPhotos() {
        guard !isLoading else { return }

        isLoading = true

        let targetString = String(target)
        let urlString = "https://api.unsplash.com/search/photos?page=\(currentPage)&per_page=50&query=\(targetString)&client_id=OAwqX_0UpKdLNae1bWy9TKfiKp8I7KE1HtIU9-Xdfg8"
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let jsonResult = try JSONDecoder().decode(APIResponce.self, from: data)
                
                DispatchQueue.main.async {
                    self?.results.append(contentsOf: jsonResult.results)
                    self?.currentPage += 1
                    self?.isLoading = false
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}



extension CollectiovViewImageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configurate(with: imageURLString)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedResult = results[indexPath.row]
        let detailViewController = PhotoDetailViewController(result: selectedResult)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            fetchPhotos()
        }
    }
}
