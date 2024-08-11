struct BadUser {
  let firstName: String
  let lastName: String
  // Userに関連するpropertyが続く・・・
  var fullName: String {
    return "\(firstName) \(lastName)"
  }
  // 省略
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
  
  func compareName(user: BadUser) -> Bool {
    return firstName == user.firstName && lastName == user.lastName
  }
}

