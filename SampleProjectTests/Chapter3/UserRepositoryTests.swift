import XCTest
@testable import SampleProject

final class UserRepositoryTests: XCTestCase {
  
  func test_bad_user_repository() {
    let profileRepository = BadUserRepository(requestType: .profile)
    XCTAssertEqual(profileRepository.path, "/user/v1/profile")
    XCTAssertEqual(profileRepository.testParameter, [["key1": "value1"], ["key2": "value2"]])
    
    let activityRepository = BadUserRepository(requestType: .activity)
    XCTAssertEqual(activityRepository.path, "/user/v2/activity")
    XCTAssertEqual(activityRepository.testParameter, [["key3": "value1"], ["key4": "value2"]])
  }
  
  func test_good_user_repository() {
    let profileRepository: UserRepositoryProtocol = GoodUserProfileRepository()
    XCTAssertEqual(profileRepository.path, "/user/v1/profile")
    XCTAssertEqual(profileRepository.testParamater, [["key1": "value1"], ["key2": "value2"]])
    
    let activityRepository: UserRepositoryProtocol = GoodUserActivityRepository()
    XCTAssertEqual(activityRepository.path, "/user/v2/activity")
    XCTAssertEqual(activityRepository.testParamater, [["key3": "value1"], ["key4": "value2"]])
  }
}

extension BadUserRepository {
  var testParameter: [[String: String]] {
    self.getParameter(value1: "value1", value2: "value2")
  }
}

extension UserRepositoryProtocol {
  var testParamater: [[String: String]] {
    guard let parameter = self.getParameter(value1: "value1", value2: "value2") as? [[String: String]] else {
      return []
    }
    return parameter
  }
}
