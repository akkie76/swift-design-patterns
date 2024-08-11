import Foundation

struct BadUserRepository {
  let requestType: RequestType
  
  init(requestType: RequestType) {
    self.requestType = requestType
  }
  
  var path: String {
    switch requestType {
    case .profile:
      return "/user/v1/profile"
    case .activity:
      return "/user/v2/activity"
    case .followers:
      return "/user/v3/followers"
    case .following:
      return "/user/v4/following"
      // 以降、RequestTypeのcaseが続く・・・
    }
  }
  
  func getParameter(value1: String, value2: String) -> [[String: String]] {
    switch requestType {
    case .profile:
      return [["key1": value1], ["key2": value2]]
    case .activity:
      return [["key3": value1], ["key4": value2]]
    case .followers:
      return [["key5": value1], ["key6": value2]]
    case .following:
      return [["key7": value1], ["key8": value2]]
      // 以降、RequestTypeのcaseが続く・・・
    }
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // リクエスト処理
    do {
      let response = try Data(contentsOf: URL(string: "content-url-response")!)
      return response
    } catch {
      throw error
    }
  }
}
