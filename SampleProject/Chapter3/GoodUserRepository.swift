import Foundation

protocol UserRepositoryProtocol {
  var path: String { get }
  func getParameter(value1: Any, value2: Any) -> [[String: Any]]
  func fetchData(value1: String, value2: String) async throws -> Data
}

struct GoodUserProfileRepository: UserRepositoryProtocol {
  var path: String {
    return "/user/v1/profile"
  }
  
  func getParameter(value1: Any, value2: Any) -> [[String : Any]] {
    return [["key1": value1], ["key2": value2]]
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // リクエスト処理
    let response = try! Data(contentsOf: URL(string: "content-url-response")!)
    return response
  }
}

struct GoodUserActivityRepository: UserRepositoryProtocol {
  var path: String {
    return "/user/v2/activity"
  }
  
  func getParameter(value1: Any, value2: Any) -> [[String : Any]] {
    return [["key3": value1], ["key4": value2]]
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // リクエスト処理
    let response = try! Data(contentsOf: URL(string: "content-url-response")!)
    return response
  }
}
