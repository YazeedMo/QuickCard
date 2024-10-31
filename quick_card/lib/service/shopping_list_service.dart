import 'package:quick_card/data/shopping_list_repository.dart';
import 'package:quick_card/entity/session.dart';
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

    Session? session = await SessionService().getCurrentSession();
    List allUserLists = await ShoppingListService().getShoppingListsByUserId(session!.currentUser!);
    ShoppingList shoppingList = await allUserLists.firstWhere((list) => list.name == 'default');
    return shoppingList;

  }

  // Get all Shopping List by user id
  Future<List<ShoppingList>> getShoppingListsByUserId(int userId) async {
    return await _shoppingListRepository.getShoppingListsByUserId(userId);
  }

  // Update shopping list
  Future<int> updateShoppingList(ShoppingList shoppingList) async {
    return await _shoppingListRepository.updateShoppingList(shoppingList);
  }

  // Delete shopping list by id
  Future<int> deleteShoppingList(int id) async {
    return await _shoppingListRepository.deleteShoppingList(id);
  }
}
