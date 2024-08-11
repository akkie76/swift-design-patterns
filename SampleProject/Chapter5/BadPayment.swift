import Foundation

struct BadPayment {
  private let identifier: String
  
  init(identifier: String) {
    self.identifier = identifier
  }
  
  func processPayment() {
    // 購入処理
  }
  
  // サブスクリプション関連のプロパティを追加
  private var subscriptionType: SubscriptionType?
  private var startedAt: Date?
  
  // サブスクリプション関連のメソッドを追加
  func processSubscription() {
    // サブスクリプションに関連する処理
    if let subscriptionType = subscriptionType, let startedAt = startedAt {
      if !enableSubscription(subscriptionType: subscriptionType, startedAt: startedAt) {
        fatalError("not available subscription.")
      }
      // その他の処理
    }
    processPayment()
  }
  
  func enableSubscription(subscriptionType: SubscriptionType, startedAt: Date) -> Bool {
    var enable = false
    // サブスクリプションの有効性をチェックする処理
    return enable
  }
}
