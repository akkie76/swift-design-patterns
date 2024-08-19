# Swift design patterns learning from Good Code and Bad Code

<p style="text-align: right">
Akihiko Sato / [@akkiee76](https://x.com/akkiee76)</p>

## Introduction

"I want to write Good Code!" This is something that every engineer aspires to. I have been an engineer for many years, and the search for "Good Code" continues even now as languages and frameworks evolve.

So, what exactly is "Good Code"? Is it code that is highly maintainable? Or is it code that is highly readable? In fact, Good Code depends on the individual engineer's perspective, so the way it is perceived may change depending on their background and career. However, I believe that "robust code that can maintain a certain level of quality" is an essential element of Good Code, not only in Swift but across various languages. In this article, I will introduce basic Swift design patterns based on implementation examples from an object-oriented perspective.

## 1. Complete Constructor

In object-oriented programming, a "complete constructor" is a constructor that initializes all the properties of an object when creating an instance. This ensures that the object cannot exist in an incomplete state and guarantees the values after initialization. A complete constructor has the following features:

* Each property in the object has its value guaranteed
* Unexpected nil references can be avoided when accessing any property of the object
* There is no need to design exception handling that accounts for nil values

In Swift, classes and structs benefit from the automatic generation of `init()` methods, which initialize the values of each property, making it easy to implement a complete constructor.

```Swift
struct User {
  let name: String
  let createdAt: Date
  let updatedAt: Date
  // optional
  init(name: String, createdAt: Date, updatedAt: Date) {
    self.name = name
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
```

Also, if you have a property that is expected to be modified externally, use `actor` to prevent simultaneous access to the same property. By specifying actor, the compiler can detect any potential data races.

```Swift
actor User {
  var name: String // expected to be modified from outside User
  let createdAt: Date
  
  init(name: String, createdAt: Date) {
    self.name = name
    self.createdAt = createdAt
  }
}
```

Next, the following code is an implementation example using prepare() for screen transitions, where userDetail is assigned during the transition. In this case, the userDetail property in ProfileViewController needs to be declared as var, which introduces the risk of unintended reassignment.

```Swift
final class UserViewController: UIViewController {
  // Omitted
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "identifier" {
      if let vc = segue.destination as? BadProfileViewController {
        vc.userDetail = response.userDetail
      }
    }
  }
}
```

In such cases, by using UIStoryboard > instantiateInitialViewController, you can assign userDetail during the initialization of ProfileViewController, allowing you to declare it as let. This eliminates the risk of unintended value reassignment, thereby enhancing the robustness of your code.

```Swift
final class ProfileViewController: UIViewController {
  private let userDetail: UserDetail
  // Omitted
  init?(coder: NSCoder, userDetail: UserDetail) {
    self.userDetail = userDetail
    super.init(coder: coder)
  }
}

final class UserViewController: UIViewController {
  // Omitted
  func showProfileViewController() {
    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
    let vc = storyboard.instantiateInitialViewController { coder in
      ProfileViewController(coder: coder, userDetail: self.response.userDetail)
    }
    navigationController?.pushViewController(vc!, animated: true)
  }
}
```

By setting the property values during initialization using a complete initializer like this, you can prevent unintended value reassignment, thereby enhancing the robustness of your code.

## 2. Value Object

A value object is a design pattern that treats values as types and has the following characteristics:

Responsible for measurement, quantification, and description
Maintains immutability of state
Can determine value equality
Provides behavior without side effects
In app development, when dealing with various values such as names, postal codes, amounts, and tax rates, aggregating these operations into objects can lead to a more robust design.

Now, let's take a look at the following code:

```Swift
struct User {
  let firstName: String
  let lastName: String

  var fullName: String {
    return "\(firstName) \(lastName)"
  }
  
  func compareName(user: User) -> Bool {
    return firstName == user.firstName && lastName == user.lastName
  }
}
```

The User struct holds information about a user, but it also implements logic related to names, such as fullName and compareName(), which makes User seem somewhat overloaded with responsibilities. Let's change this name logic to a value object. By moving name-specific logic, such as retrieving fullName and determining equality with Equatable, from User to Name, we can increase cohesion.

```Swift
struct Name: Equatable {
  let firstName: String
  let lastName: String
  
  var fullName: String {
    return "\(firstName) \(lastName)"
  }

  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
  }
}

struct User {
  let name: Name
  // Omitted
}

extension User {
  func compareName(user: User) -> Bool {
    return self.name == user.name
  }
}
```

By making this change to a value object, you can achieve a highly cohesive design. Additionally, by combining this approach with the complete initializer mentioned earlier, you can aim for an even more robust design.

##  3. Strategy Pattern

The Strategy pattern is a design pattern that encapsulates algorithms externally when it is necessary to switch between them dynamically, allowing you to choose different algorithms based on the required case. By separating the part that executes the algorithm from the part that uses it, you can achieve a design that is easier to modify. This improves the independence of the logic and the ease of testing.

On the other hand, the Policy pattern is a design pattern that, like the Strategy pattern, encapsulates algorithms or behaviors, but it specifically defines business rules or policies and provides an interface to apply these policies. This allows you to apply multiple policies to any module, making it a useful design pattern.

Let's take a look at the following code:

```Swift
struct UserRepository {
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
      // Additional cases for RequestType follow...
    }
  }
  
  func getParameter(value1: String, value2: String) -> [[String: String]] {
    switch requestType {
    case .profile:
      return [["key1": value1], ["key2": value2]]
    case .activity:
      return [["key3": value1], ["key4": value2]]
      // Additional cases for RequestType follow...
    }
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // Request processing
  }
}
```

The UserRepository is responsible for fetching user-related information via an API, depending on the requestType. The getPath() and getParameter() methods use switch statements for conditional branching, which makes the code redundant. As more cases are added in the future, the code in UserRepository will become bloated. Let's redesign this using the Strategy pattern.

```Swift
protocol UserRepositoryProtocol {
  var path: String { get }
  func getParameter(value1: Any, value2: Any) -> [[String: Any]]
  func fetchData(value1: String, value2: String) async throws -> Data
}
```

First, define a protocol and divide the responsibilities in UserRepository according to each RequestType.

```Swift
struct UserProfileRepository: UserRepositoryProtocol {
  var path: String {
    return "/user/v1/profile"
  }
  
  func getParameter(value1: Any, value2: Any) -> [[String: Any]] {
    return [["key1": value1], ["key2": value2]]
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // Request processing
  }
}
```

```Swift
struct UserProfileRepository: UserRepositoryProtocol {
  var path: String {
    return "/user/v1/profile"
  }
  
  func getParameter(value1: Any, value2: Any) -> [[String: Any]] {
    return [["key1": value1], ["key2": value2]]
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // Request processing
  }
}
```

```Swift
struct UserActivityRepository: UserRepositoryProtocol {
  var path: String {
    return "/user/v2/activity"
  }
  
  func getParameter(value1: Any, value2: Any) -> [[String: Any]] {
    return [["key3": value1], ["key4": value2]]
  }
  
  func fetchData(value1: String, value2: String) async throws -> Data {
    let parameter = getParameter(value1: value1, value2: value2)
    // Request processing
  }
}
```

Next, by conforming to the protocol and separating and redesigning the repositories according to their responsibilities, we were able to redesign using the Strategy pattern. In cases where generic classes like repositories are likely to become redundant, designing with the Strategy pattern is effective. Additionally, if a class does not conform to the protocol, a compile-time error will occur, which helps prevent omissions of required function definitions, making this an effective design pattern from the perspective of code safety. By utilizing the Strategy pattern, you can redesign complex, intertwined implementations into simpler ones.

##  4. First Class Collection

First-Class Collection is a design pattern to approach where a collection (such as a List, Set, or Map) is treated as an object itself, allowing you to isolate logic specific to the collection. This can lead to better separation of concerns, increased reusability, and improved testability.

Now, let's take a look at the following code:

```Swift
func addItem(_ item: Item) {
  if items.count == 10 {
    fatalError("already max count.")
  }
  if items.firstIndex(where: { $0.id == item.id }) == nil {
    return
  }
  items.append(item)
}
```

This addItem function adds an element to its items, but it includes responsibilities for validating the number of elements, checking for duplicates, and adding the element—all within the same function. Additionally, because elements are added directly to items, there is a risk of side effects. Let's refactor this code using First-Class Collection to separate these responsibilities and change it to an object that avoids side effects.

```Swift
struct ItemCollection {
  private let items: [Item]
  private let maxCount = 10
  
  init(items: [Item]) {
    self.items = items
  }
  
  func add(item: Item) -> ItemCollection {
    if isMaxCount() {
      fatalError("already max count.")
    }
    if contains(item: item) {
      return self
    }
    var newItems = items
    newItems.append(item)
    return ItemCollection(items: newItems)
  }
  
  func contains(item: Item) -> Bool {
    return items.firstIndex(where: { $0.id == item.id }) != nil
  }
  
  func isMaxCount() -> Bool {
    return items.count == maxCount
  }
}
```

In this example, we've created an ItemCollection, and by encapsulating the responsibilities for element count validation, duplicate checking, and adding elements into separate functions, we've achieved a better separation of concerns. When adding elements, items is not modified directly, which helps to avoid side effects.

By designing with First-Class Collection, you can handle collections more safely.

## 5. Sprout Class

The Sprout Class is a technique used to extend the functionality of an existing class by extracting the necessary features into a separate class, which is then utilized by the existing class. This allows you to add new functionality without directly modifying the existing class, thereby minimizing its impact.

Let's take a look at the following code, where a subscription feature has been added to an existing Payment class responsible for regular billing.

```Swift
struct Payment {
  private let identifier: String
  
  init(identifier: String) {
    self.identifier = identifier
  }
  
  func processPayment() {
    // Purchase processing
  }
  
  // Added properties related to subscriptions
  private var subscriptionType: SubscriptionType?
  private var startedAt: Date?
  
  // Added methods related to subscriptions
  func processSubscription() {
    if let subscriptionType = subscriptionType, let startedAt = startedAt {
      if !enableSubscription(subscriptionType: subscriptionType, startedAt: startedAt) {
        fatalError("not available subscription.")
      }
      // Other processing
    }
    processPayment()
  }
  
  func enableSubscription(subscriptionType: SubscriptionType, startedAt: Date) -> Bool {
    // Check the validity of the subscription
    return enable
  }
}
```

The Payment class now includes subscription processing, increasing its responsibilities. By defining both the regular purchase processing with processPayment() and the subscription purchase processing with processSubscription(), the related logic also increases, making the code more complex. Let's use the Sprout Class to separate this subscription functionality from Payment and reduce its responsibilities.

```Swift
protocol PaymentProtocol {
  var identifier: String { get }
  func processPayment()
}

extension PaymentProtocol {
  func processPayment() {
    // Purchase processing
  }
}

struct Payment: PaymentProtocol {
  var identifier: String
  
  init(identifier: String) {
    self.identifier = identifier
  }
}
```

```Swift
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
    // Other processing
    processPayment()
  }
  
  func enable() -> Bool {
    // Check if the subscription is valid
    return enable
  }
}
```
By defining a protocol for the common processPayment() method shared between Payment and SubscriptionPayment, we moved the logic into the extension. Then, we added the subscription-related logic to SubscriptionPayment, separating the responsibilities and avoiding the impact and bloating of Payment. This also improves the independence and testability of SubscriptionPayment.

In this way, by using a Sprout Class, you can safely add new functionality without directly modifying the existing implementation, while also enhancing the independence and testability of the logic.

## Conclusion

In this article, I introduced fundamental Swift design patterns based on object-oriented principles. I hope this article serves as a valuable resource that contributes to the improvement of developers' skills and the success of your projects. Please note that this article is intended for informational purposes only, and any operations based on it should be carried out at your own discretion and responsibility.

### Thoughts and Feedback

I look forward to hearing your thoughts and feedback on this article via my X account: [@akkiee76](https://x.com/akkiee76). Please feel free to send in your comments, whether it's about what you liked or what was hard to understand, as it will help inform my future writing. Additionally, the sample code discussed in this article is available on the following GitHub repository. If you have any suggestions or questions, I also welcome Pull Requests or Issues.