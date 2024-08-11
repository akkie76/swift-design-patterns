import Foundation

protocol PaymentProtocol {
  var identifier: String { get }
  func processPayment()
}

extension PaymentProtocol {
  func processPayment() {
    // 購入処理
    print(identifier)
  }
}

struct Payment: PaymentProtocol {
  var identifier: String
  
  init(identifier: String) {
    self.identifier = identifier
  }
}

struct SubscriptionPayment: PaymentProtocol {
  var identifier: String
  let subscriptionType: SubscriptionType
  let startedAt: Date
  
  init(identifier: String, subscriptionType: SubscriptionType, startedAt: Date) {
    self.identifier = identifier
    self.subscriptionType = subscriptionType
    self.startedAt = startedAt
  }
  
  func processSubscription() {
    if !enable() {
      fatalError("not available subscription.")
    }
    // その他の処理
    processPayment()
  }
  
  func enable() -> Bool {
    var enable = true
    // サブスクリプションが有効化チェックする処理
    return enable
  }
}
