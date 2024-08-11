import XCTest
@testable import SampleProject

final class ItemCollectionTests: XCTestCase {
  
  func test() {
    let items = (1...9).map { self.createItem(id: $0) }
    let itemCollection = ItemCollection(items: items)
    let addedItemCollection = itemCollection.add(item: createItem(id: 10))
    
    XCTAssertEqual(itemCollection.items.count, 9)
    XCTAssertEqual(addedItemCollection.items.count, 10)
    
    XCTAssertTrue(itemCollection.contains(item: createItem(id: 1)))
    XCTAssertFalse(itemCollection.contains(item: createItem(id: 10)))
    
    XCTAssertFalse(itemCollection.isMaxCount())
    XCTAssertTrue(addedItemCollection.isMaxCount())
  }
  
  func createItem(id: Int) -> Item {
    return Item(id: id, name: "Item \(id)")
  }
}
