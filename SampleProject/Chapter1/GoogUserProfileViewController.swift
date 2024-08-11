import UIKit

final class GoogUserProfileViewController: UIViewController {
  private var response: Response!
  
  func showProfileViewController() {
    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
    let vc = storyboard.instantiateInitialViewController { coder in
      GoodProfileViewController(coder: coder, userDetail: self.response.userDetail)
    }
    navigationController?.pushViewController(vc!, animated: true)
  }
}

final class GoodProfileViewController: UIViewController {
  private let userDetail: UserDetail!
  
  init?(coder: NSCoder, userDetail: UserDetail) {
    self.userDetail = userDetail
    super.init(coder: coder)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
