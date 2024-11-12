import 'package:quick_card/repository/item_repository.dart';
import 'package:quick_card/entity/item.dart';
import 'package:quick_card/entity/session.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:quick_card/service/session_service.dart';
import 'package:quick_card/service/shopping_list_service.dart';

class ItemService {
  final ItemRepository _itemRepository = ItemRepository();

  // Create new item
  Future<int> createItem(Item item) async {
    return await _itemRepository.createItem(item);
  }

  // Get all Items by Shopping List Id
  Future<List<Item>> getAllItemsByShoppingListId(int id) async {
    return await _itemRepository.getItemsByShoppingListId(id);
  }

  // Get all Current User items
  Future<List<Item>> getAllCurrentUserItems() async {

    Session? session = await SessionService().getCurrentSession();
    List<ShoppingList> allUserLists = await ShoppingListService().getShoppingListsByUserId(session!.currentUser!);
    List<Item> allUserItems = [];
    for (ShoppingList shoppingList in allUserLists) {
      List<Item> allListItems = await getAllItemsByShoppingListId(shoppingList.id!);
      allUserItems.addAll(allListItems);
    }
    return allUserItems;

  }

  // Get item by id
  Future<Item?> getItemById(int id) async {
    Item? item = await _itemRepository.getItemById(id);

    if (item != null) {
      return item;
    }

    return null;
  }

  // Update Item
  Future<Item?> updateItem(Item item) async {
    int updatedItemId = await _itemRepository.updateItem(item);
    return getItemById(updatedItemId);
  }

  // Delete Item by Id
  Future<int> deleteItemById(int id) async {
    return await _itemRepository.deleteItem(id);
  }
}
