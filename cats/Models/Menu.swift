import Foundation

enum MenuType {
    case segue(_ segue: String)
    case safari(_ link: String)
    case notification(_ title: String)
}

struct Menu {
    let name: String
    let type: MenuType
}
