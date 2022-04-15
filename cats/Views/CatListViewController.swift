import UIKit
import RealmSwift



class CatListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private let realm = try! Realm()
    private var cats = [Cat]()
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        loadCats()
    }
    
    private func loadCats() {
        self.cats = Array(realm.objects(Cat.self))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCat" {
            let destination = segue.destination as! AddOrEditCatViewController
            let cat = sender as! Cat
            destination.catId = cat.id
        }
    }
    
    @IBAction func unwindFromEdit(segue: UIStoryboardSegue) {
        loadCats()
        collectionView.reloadData()
    }
}

extension CatListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        let label = cell.viewWithTag(2) as! UILabel
        
        let cat = cats[indexPath.row]
        
        if let imageData = cat.image {
            imageView.image = UIImage(data: imageData)
        }
        
        label.text = cat.name
        
        return cell
    }
}

extension CatListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 200, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cat = cats[indexPath.row]
        performSegue(withIdentifier: "editCat", sender: cat)
    }
}
