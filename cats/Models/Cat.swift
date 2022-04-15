import RealmSwift
import Foundation

class Cat: Object {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name: String
    @Persisted var breed: String
    @Persisted var age: Int
    @Persisted var image: Data?
}
