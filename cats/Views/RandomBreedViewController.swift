import UIKit
import Alamofire

class RandomBreedViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        AF.request(
            "https://api.thecatapi.com/v1/breeds",
            headers: [
                "x-api-key": catApiKey
            ]
        ).responseDecodable(of: [BreedDTO].self) { [self] response in
            let breeds = response.value!
            label.text = breeds.randomElement()?.name
        }
    }
}
