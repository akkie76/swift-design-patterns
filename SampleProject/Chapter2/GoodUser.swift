import Foundation

struct Name: Equatable {
  let firstName: String
  let lastName: String
  
  var fullName: String {
    return "\(firstName) \(lastName)"
  }
  // 省略
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

struct GoodUser {
  let name: Name
  // 省略
  init(firstName: String, lastName: String) {
    self.name = Name(firstName: firstName, lastName: lastName)
  }
}

extension GoodUser {
  func compareName(user: GoodUser) -> Bool {
    return self.name == user.name
  }
}
