import UIKit
import RealmSwift
import PhotosUI

let catInfo = ["Name", "Breed", "Age"]

class AddOrEditCatViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var animation1Button: UIButton!
    @IBOutlet weak var animation2Button: UIButton!
    
    var catId: Int?
    
    let realm = try! Realm()
    
    @IBAction func addCat(_ sender: Any) {
        try! realm.write {
            let cat: Cat
            if let catId = catId {
                cat = realm.object(ofType: Cat.self, forPrimaryKey: catId)!
            } else {
                cat = Cat()
                cat.id = Cat.nextId
            }
            cat.name = nameTextField.text ?? ""
            cat.breed = breedTextField.text ?? ""
            cat.age = Int(ageTextField.text!) ?? 0
            cat.image = imageView.image?.pngData()
            if catId == nil {
                realm.add(cat)
            }
        }
        goBack()
    }
    
    private func goBack() {
        if catId != nil {
            performSegue(withIdentifier: "unwindFromEdit", sender: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func deleteCat(_ sender: Any) {
        if let cat = realm.object(ofType: Cat.self, forPrimaryKey: catId) {
            try! realm.write {
                realm.delete(cat)
            }
        }
        goBack()
    }
    
    @IBAction func shareCat(_ sender: Any) {
        if let cat = realm.object(ofType: Cat.self, forPrimaryKey: catId) {
            let items = ["Here is my cat: \(cat.name)"]
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(activityViewController, animated: true)
        }
    }
    
    @IBAction func animation1(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            imageView.alpha = 0
        }, completion: {_ in
            UIView.animate(withDuration: 0.5) { [self] in
                imageView.alpha = 1
            }
        })
    }
    
    @IBAction func animation2(_ sender: Any) {
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 1
        scaleDown.toValue = 0.5
        scaleDown.duration = 1
        
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.fromValue = 0.5
        scaleUp.toValue = 1
        scaleUp.duration = 1
        scaleUp.beginTime = 1
        
        let animations = CAAnimationGroup()
        animations.duration = 2
        animations.repeatCount = 1
        animations.animations = [scaleDown, scaleUp]
        
        imageView.layer.add(animations, forKey: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = "Tap to add image".image(
            attributes: [
                .foregroundColor: UIColor.gray
            ],
            size: .init(
                width: 100,
                height: imageView.frame.size.height
            )
        )
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(onImagePress)
            )
        )
        
        if let catId = catId {
            title = "Edit cat \(catId)"
            actionButton.titleLabel?.text = "Edit"
            deleteButton.isHidden = false
            shareButton.isHidden = false
            animation1Button.isHidden = false
            animation2Button.isHidden = false
            
            if let cat = realm.object(ofType: Cat.self, forPrimaryKey: catId) {
                nameTextField.text = cat.name
                breedTextField.text = cat.breed
                ageTextField.text = String(cat.age)
                if let imageData = cat.image {
                    imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @objc private func onImagePress() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
}

extension AddOrEditCatViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        if results.count == 1 {
            let result = results[0]
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async { [self] in
                        imageView.image = image
                    }
                }
            })
        }
    }
}
