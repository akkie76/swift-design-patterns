import Foundation

import XCTest
@testable import SampleProject

final class PurchaseTests: XCTestCase {
  
  func test() {
    let payment = Payment(identifier: "payment")
    XCTAssertNoThrow(payment.processPayment())
    
    let subscriptionPayment = SubscriptionPayment(identifier: "subscription", subscriptionType: .month, startedAt: Date())
    XCTAssertNoThrow(subscriptionPayment.processSubscription())
  }
}
