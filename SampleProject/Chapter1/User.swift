import Foundation

actor User {
  var name: String // User外から変更される
  private let createdAt: Date
  
  init(name: String, createdAt: Date) {
    self.name = name
    self.createdAt = createdAt
  }
}
