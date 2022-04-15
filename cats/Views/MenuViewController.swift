import UIKit
import SafariServices

let menus = [
    Menu(name: "Cat list", type: .segue("catList")),
    Menu(name: "Add cat", type: .segue("addCat")),
    Menu(name: "Random breed", type: .segue("randomBreed")),
    Menu(name: "Random image", type: .segue("randomImage")),
    Menu(name: "Random video", type: .segue("randomVideo")),
    Menu(name: "Cat info", type: .safari("https://en.wikipedia.org/wiki/Cat")),
    Menu(name: "Receive notification", type: .notification("Meow")),
    Menu(name: "Cat cafe map", type: .segue("catMap"))
]

class MenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = menus[indexPath.row]
        switch menu.type {
        case .segue(let segue):
            performSegue(withIdentifier: segue, sender: nil)
        case .safari(let url):
            let config = SFSafariViewController.Configuration()            
            let safari = SFSafariViewController(url: URL(string: url)!, configuration: config)
            present(safari, animated: true)
        case .notification(let title):
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                if success {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.sound = UNNotificationSound.default

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request)
                }
            }
        }
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let menu = menus[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = menu.name
        cell.contentConfiguration = content
        return cell
    }
}

