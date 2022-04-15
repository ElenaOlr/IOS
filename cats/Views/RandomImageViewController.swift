import UIKit
import Alamofire

class RandomImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        imageView.image = "Loading...".image(
            attributes: [
                .foregroundColor: UIColor.gray
            ],
            size: .init(
                width: 100,
                height: imageView.frame.size.height
            )
        )
        AF.request(
            "https://api.thecatapi.com/v1/images/search",
            headers: [
                "x-api-key": catApiKey
            ]
        ).responseDecodable(of: [BreedImageDTO].self) { [self] response in
            let breeds = response.value!
            let url = URL(string: breeds.randomElement()!.url)!
            let data = try! Data(contentsOf: url)
            imageView.image = UIImage(data: data)
        }
    }
}
