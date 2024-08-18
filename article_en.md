# Swift design patterns learning from Good Code and Bad Code

<p style="text-align: right">
Akihiko Sato / @akkiee76</p>

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