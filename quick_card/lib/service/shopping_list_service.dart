import 'package:quick_card/repository/shopping_list_repository.dart';
import 'package:quick_card/entity/shopping_list.dart';
import 'package:quick_card/service/session_service.dart';

class ShoppingListService {
  final ShoppingListRepository _shoppingListRepository =
      ShoppingListRepository();

  // Create new Shopping list
  Future<int> createShoppingList(ShoppingList shoppingList) async {
    return await _shoppingListRepository.createShoppingList(shoppingList);
  }

  // Get current User's default Shopping List
  Future<ShoppingList> getCurrentUserDefaultShoppingList() async {
    int currentUserId = await SessionService().getCurrentUserId();
    List allUserLists = await ShoppingListService()
        .getShoppingListsByUserId(currentUserId);
    ShoppingList shoppingList =
        await allUserLists.firstWhere((list) => list.name == 'default');
    return shoppingList;
  }

  // Get all ShoppingLists by User id
  Future<List<ShoppingList>> getShoppingListsByUserId(int userId) async {
    return await _shoppingListRepository.getShoppingListsByUserId(userId);
  }

  // Update ShoppingList
  Future<int> updateShoppingList(ShoppingList shoppingList) async {
    return await _shoppingListRepository.updateShoppingList(shoppingList);
  }

  // Delete shoppingList by id
  Future<int> deleteShoppingList(int id) async {
    return await _shoppingListRepository.deleteShoppingList(id);
  }
}
