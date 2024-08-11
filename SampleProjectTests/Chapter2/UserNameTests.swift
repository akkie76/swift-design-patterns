
import XCTest
@testable import SampleProject

final class UserNameTests: XCTestCase {
  
  func test_bad_user() {
    let user1 = BadUser(firstName: "山田", lastName: "太郎")
    let user2 = BadUser(firstName: "山田", lastName: "太郎")
    XCTAssertTrue(user1.compareName(user: user2))
    
    let user3 = BadUser(firstName: "山本", lastName: "太郎")
    XCTAssertFalse(user1.compareName(user: user3))
  }
  
  func test_good_user() {
    let user1 = GoodUser(firstName: "山田", lastName: "太郎")
    let user2 = GoodUser(firstName: "山田", lastName: "太郎")
    XCTAssertTrue(user1.compareName(user: user2))
    
    let user3 = GoodUser(firstName: "山本", lastName: "太郎")
    XCTAssertFalse(user1.compareName(user: user3))
  }
}
