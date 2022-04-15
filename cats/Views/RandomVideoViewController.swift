import UIKit
import YouTubeiOSPlayerHelper

class RandomVideoViewController: UIViewController {
    override func viewDidLoad() {
        let view = self.view as! YTPlayerView
        view.load(withVideoId: ["W85oD8FEF78", "kEPfM3jSoBw"].randomElement()!)
    }
}
