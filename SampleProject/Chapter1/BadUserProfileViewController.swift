import UIKit

struct Response {
  let userDetail: UserDetail
}

final class BadUserViewController: UIViewController {
  private var response: Response!
  // 省略
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifier" {
      let vc = segue.destination as! BadProfileViewController
      vc.userDetail = response.userDetail
    }
  }
}

final class BadProfileViewController: UIViewController {
  // BadProfileViewControllerで使用するパラメータ群
  var userDetail: UserDetail!
}
