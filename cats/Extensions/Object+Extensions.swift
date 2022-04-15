import RealmSwift

extension Object {
    static var nextId: Int {
        let realm = try! Realm()
        return (realm.objects(Self.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
