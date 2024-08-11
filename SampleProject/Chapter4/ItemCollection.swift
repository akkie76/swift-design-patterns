import Foundation

struct Item {
  let id: Int
  let name: String
}

struct ItemCollection {
  let items: [Item]
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
