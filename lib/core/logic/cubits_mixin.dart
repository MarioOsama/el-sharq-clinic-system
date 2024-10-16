import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/logic/identifiable_model.dart';
import 'package:flutter/material.dart';

/// A mixin that provides common functionality for managing a list of items
/// in a Cubit. This mixin is intended to be used with a Cubit that manages
/// a state of type `TState` and a list of items of type `T` where `T` extends
/// `IdentifiableModel`.
///
/// The mixin provides methods for:
/// - Fetching paginated items
/// - Processing an item (add, update, delete)
/// - Validating and saving an item
/// - Validating and updating an item
/// - Deleting an item
/// - Deleting multiple items
/// - Searching for items
/// - Handling multi-selection of items
///
/// It also maintains the state of the items list, search results, selected rows,
/// and a notifier for showing the delete button.
///
/// Type Parameters:
/// - `T`: The type of the items, which must extend `IdentifiableModel`.
/// - `TState`: The type of the state managed by the Cubit.
///
/// Properties:
/// - `itemsList`: A list of items of type `T`.
/// - `searchResult`: A list of search results of type `T`.
/// - `selectedRows`: A list of booleans indicating the selected rows.
/// - `showDeleteButtonNotifier`: A `ValueNotifier` for showing the delete button.
///
/// Methods:
/// - `fetchPaginatedItems`: Fetches paginated items and updates the state.
/// - `_onGetItemsSuccess`: Handles the success of fetching items.
/// - `_processItem`: Processes an item (add, update, delete) and updates the state.
/// - `validateAndSaveItem`: Validates and saves an item.
/// - `onNewItemAdded`: Handles the success of adding a new item.
/// - `validateAndUpdateItem`: Validates and updates an item.
/// - `onItemUpdated`: Handles the success of updating an item.
/// - `deleteItem`: Deletes an item.
/// - `onItemDeleted`: Handles the success of deleting an item.
/// - `deleteItems`: Deletes multiple items.
/// - `onItemsDeleted`: Handles the success of deleting multiple items.
/// - `getItemById`: Retrieves an item by its ID.
/// - `searchForItems`: Searches for items and updates the state.
/// - `onItemsMultiSelection`: Handles the multi-selection of items.
/// - `_handleSuccess`: Handles the success state.
/// - `_resetShowDeleteButtonNotifier`: Resets the delete button notifier.
/// - `getDeletedItemsIds`: Retrieves the IDs of the deleted items.
mixin CubitsMixin<T extends IdentifiableModel, TState> on Cubit<TState> {
  List<T?> itemsList = [];
  List<T?> searchResult = [];
  List<bool> selectedRows = [];
  ValueNotifier<bool> showDeleteButtonNotifier = ValueNotifier(false);

  /// Fetches paginated items and handles success and failure states.
  ///
  /// This method attempts to fetch a list of items using the provided [fetchItems]
  /// function. On successful fetch, it calls the [onSuccess] callback with the
  /// fetched items and emits the [successState]. If an error occurs during the
  /// fetch, it emits the [failureState].
  ///
  /// Parameters:
  /// - [successState]: The state to emit upon successful fetch.
  /// - [failureState]: The state to emit if the fetch fails.
  /// - [fetchItems]: A function that returns a `Future` containing the list of items to fetch.
  /// - [onSuccess]: A callback function that is called with the fetched items on success.
  /// - [lastItemId]: An optional parameter representing the ID of the last item fetched.
  ///
  /// Returns:
  /// A `Future` that completes when the fetch operation is done.
  Future<void> fetchPaginatedItems({
    required TState successState,
    required TState failureState,
    required Future<List<T>> Function() fetchItems,
    required void Function(List<T> items) onSuccess,
    String? lastItemId,
  }) async {
    try {
      final List<T> items = await fetchItems();
      _onGetItemsSuccess(items);
      emit(successState);
    } catch (e) {
      emit(failureState);
    }
  }

  /// Called when the items list is successfully fetched.
  ///
  /// This method adds the new items to the existing items list and resets the
  /// selected rows list.
  ///
  /// Parameters:
  /// - [newItemsList]: The list of items to add to the existing items list.
  ///
  void _onGetItemsSuccess(List<T> newItemsList) {
    itemsList.addAll(newItemsList);
    selectedRows = List.filled(itemsList.length, false);
  }

  /// Processes an item (add, update, delete) and updates the state.
  ///
  /// This method emits the [loadingState] and then executes the provided
  /// [futureAction]. If the action is successful, it emits the
  /// [successActionState] and then calls the [onSuccess] callback with the
  /// processed item and the [successState]. If the action fails, it emits the
  /// [failureState].
  ///
  /// Parameters:
  /// - [loadingState]: The state to emit while the action is being processed.
  /// - [successActionState]: The state to emit when the action is successfully
  ///   completed.
  /// - [successState]: The state to emit when the action is completed and the
  ///   item is successfully processed.
  /// - [failureState]: The state to emit when the action fails.
  /// - [item]: The item to process.
  /// - [futureAction]: A function that returns a `Future` containing the result
  ///   of the action.
  /// - [onSuccess]: A callback function that is called with the processed item
  ///   and the [successState].
  ///
  /// Returns:
  /// A `Future` that completes when the action is done.
  Future<void> _processItem({
    required TState loadingState,
    required TState successActionState,
    required TState successState,
    required TState failureState,
    required T item,
    required Future Function() futureAction,
    required void Function(T item, TState successState) onSuccess,
  }) async {
    emit(loadingState);
    final bool successAddition = await futureAction();
    if (successAddition) {
      emit(successActionState);
      onSuccess(item, successState);
    } else {
      emit(failureState);
    }
  }

  /// Validates the provided [newItem] by calling the provided [validation]
  /// function. If the validation is successful, it calls the provided
  /// [addNewItem] `Future` and processes the result using the
  /// [_processItem] method. If the validation fails, it emits the
  /// [invalidState].
  ///
  /// Parameters:
  /// - [loadingState]: The state to emit while the action is being processed.
  /// - [successSavingState]: The state to emit when the action is successfully
  ///   completed.
  /// - [successState]: The state to emit when the action is completed and the
  ///   item is successfully processed.
  /// - [failureState]: The state to emit when the action fails.
  /// - [invalidState]: The state to emit when the validation fails.
  /// - [newItem]: The item to validate and process.
  /// - [addNewItem]: A function that returns a `Future` containing the result
  ///   of adding the new item.
  /// - [validation]: A function that returns a boolean indicating the result of
  ///   the validation.
  Future<void> validateAndSaveItem({
    required TState loadingState,
    required TState successSavingState,
    required TState successState,
    required TState failureState,
    required TState invalidState,
    required T newItem,
    required Future Function() addNewItem,
    required bool Function() validation,
  }) async {
    if (validation()) {
      await _processItem(
        loadingState: loadingState,
        successActionState: successSavingState,
        successState: successState,
        failureState: failureState,
        item: newItem,
        futureAction: addNewItem,
        onSuccess: onNewItemAdded,
      );
    } else {
      emit(invalidState);
    }
  }

  /// Handles the success of adding a new item by inserting it at the beginning of the items list
  /// and triggering the success state handling.
  void onNewItemAdded(T newItem, TState successState) {
    itemsList.insert(0, newItem);
    _handleSuccess(successState);
  }

  /// Validates and updates an item based on the provided states and actions.
  ///
  /// This method first checks if the item passes the validation function. If the
  /// validation is successful, it processes the item by calling the provided
  /// update function and transitions through the specified states. If the
  /// validation fails, it emits the invalid state.
  ///
  /// Parameters:
  /// - `loadingState`: The state to emit while the item is being processed.
  /// - `successUpdatingState`: The state to emit when the item update is successful.
  /// - `successState`: The state to emit when the entire process is successful.
  /// - `failureState`: The state to emit if the item update fails.
  /// - `invalidState`: The state to emit if the item fails validation.
  /// - `updatedItem`: The item to be updated.
  /// - `updateItem`: A function that performs the update operation.
  /// - `validation`: A function that validates the item.
  ///
  /// Returns:
  /// A `Future<void>` that completes when the item has been processed.
  Future<void> validateAndUpdateItem({
    required TState loadingState,
    required TState successUpdatingState,
    required TState successState,
    required TState failureState,
    required TState invalidState,
    required T updatedItem,
    required Future Function() updateItem,
    required bool Function() validation,
  }) async {
    if (validation()) {
      await _processItem(
        loadingState: loadingState,
        successActionState: successUpdatingState,
        successState: successState,
        failureState: failureState,
        item: updatedItem,
        futureAction: updateItem,
        onSuccess: onItemUpdated,
      );
    } else {
      emit(invalidState);
    }
  }

  /// Updates an item in the `itemsList` with the provided `updatedItem` and
  /// transitions to the given `successState`.
  ///
  /// This method finds the index of the item in the `itemsList` that matches
  /// the `id` of the `updatedItem`, replaces it with the `updatedItem`, and
  /// then calls `_handleSuccess` with the `successState`.
  ///
  /// - Parameters:
  ///   - updatedItem: The item to update in the list.
  ///   - successState: The state to transition to after the item is updated.
  void onItemUpdated(T updatedItem, TState successState) {
    final int index =
        itemsList.indexWhere((element) => element!.id == updatedItem.id);
    itemsList[index] = updatedItem;
    _handleSuccess(successState);
  }

  /// Deletes an item and updates the state accordingly.
  ///
  /// This method handles the deletion of an item by processing the necessary
  /// state transitions. It first sets the state to a loading state, then
  /// attempts to delete the item, and finally updates the state based on the
  /// result of the deletion.
  ///
  /// The method requires several states to be provided for different stages
  /// of the process:
  /// - [loadingState]: The state to set when the deletion process starts.
  /// - [successDeletionState]: The state to set when the item is successfully deleted.
  /// - [successState]: The state to set when the entire process is successful.
  /// - [failureState]: The state to set if the deletion process fails.
  ///
  /// Additionally, the method requires:
  /// - [itemId]: The ID of the item to be deleted.
  /// - [deleteItem]: A function that performs the actual deletion of the item.
  ///
  /// The method uses [_processItem] to handle the state transitions and
  /// perform the deletion.
  ///
  /// Parameters:
  /// - `loadingState`: The state to set when the deletion process starts.
  /// - `successDeletionState`: The state to set when the item is successfully deleted.
  /// - `successState`: The state to set when the entire process is successful.
  /// - `failureState`: The state to set if the deletion process fails.
  /// - `itemId`: The ID of the item to be deleted.
  /// - `deleteItem`: A function that performs the actual deletion of the item.
  ///
  /// Returns:
  /// - A [Future] that completes when the deletion process is finished.
  Future<void> deleteItem({
    required TState loadingState,
    required TState successDeletionState,
    required TState successState,
    required TState failureState,
    required String itemId,
    required Future Function() deleteItem,
  }) async {
    _processItem(
      loadingState: loadingState,
      successActionState: successDeletionState,
      successState: successState,
      failureState: failureState,
      item: getItemById(itemId),
      futureAction: deleteItem,
      onSuccess: onItemDeleted,
    );
  }

  /// Handles the deletion of an item from the list and updates the state accordingly.
  ///
  /// Removes the specified [item] from the [itemsList] and then calls the
  /// [_handleSuccess] method with the provided [successState].
  ///
  /// - Parameters:
  ///   - item: The item to be deleted from the list.
  ///   - successState: The state to be set after the item is successfully deleted.
  void onItemDeleted(T item, TState successState) {
    itemsList.removeWhere((element) => element!.id == item.id);
    _handleSuccess(successState);
  }

  /// Deletes a list of items and updates the state accordingly.
  ///
  /// This method emits a loading state, attempts to delete each item in the provided list,
  /// and then emits either a success or failure state based on the outcome.
  ///
  /// Parameters:
  /// - `loadingState`: The state to emit while the deletion is in progress.
  /// - `successDeletionState`: The state to emit after all items have been successfully deleted.
  /// - `successState`: The state to emit after the items have been successfully deleted and processed.
  /// - `failureState`: The state to emit if an error occurs during the deletion process.
  /// - `deleteItem`: A function that takes an item ID and deletes the corresponding item.
  /// - `itemsIds`: A list of item IDs to be deleted.
  ///
  /// Returns:
  /// A `Future` that completes when the deletion process is finished.
  Future<void> deleteItems({
    required TState loadingState,
    required TState successDeletionState,
    required TState successState,
    required TState failureState,
    required Future Function(String itemId) deleteItem,
    required List<String> itemsIds,
  }) async {
    emit(loadingState);
    try {
      for (String itemId in itemsIds) {
        await deleteItem(itemId);
      }
      emit(successDeletionState);
      onItemsDeleted(itemsIds, successState);
    } catch (e) {
      emit(failureState);
    }
  }

  /// Deletes items from the list based on their IDs and updates the state.
  ///
  /// This method removes items from `itemsList` whose IDs are present in the
  /// `deletedItemsIds` list. After deletion, it resets the delete button notifier
  /// and handles the success state.
  ///
  /// - Parameters:
  ///   - deletedItemsIds: A list of IDs of the items to be deleted.
  ///   - successState: The state to be set upon successful deletion.
  ///
  /// Retrieves an item by its ID from the search results or the main list.
  ///
  /// This method attempts to find an item with the given `itemId` in the
  /// `searchResult` list first. If not found, it searches in the `itemsList`.
  ///
  /// - Parameter itemId: The ID of the item to be retrieved.
  /// - Returns: The item with the specified ID.
  void onItemsDeleted(List<String> deletedItemsIds, TState successState) {
    for (String itemId in deletedItemsIds) {
      itemsList.removeWhere((element) => element!.id == itemId);
    }
    _resetShowDeleteButtonNotifier();
    _handleSuccess(successState);
  }

  /// Retrieves an item by its ID from the search results or the items list.
  ///
  /// This method first attempts to find the item in the `searchResult` list.
  /// If the item is not found in `searchResult`, it then searches in the `itemsList`.
  ///
  /// Throws:
  /// - `StateError` if no element is found in either list.
  ///
  /// Returns:
  /// - The item of type `T` that matches the given `itemId`.
  ///
  /// Parameters:
  /// - `itemId`: The ID of the item to be retrieved.
  T getItemById(String itemId) {
    try {
      return searchResult.firstWhere((element) => element!.id == itemId) as T;
    } catch (e) {
      return itemsList.firstWhere((element) => element!.id == itemId) as T;
    }
  }

  /// Searches for items and updates the state accordingly.
  ///
  /// This method performs a search operation and emits different states based on the result of the search.
  ///
  /// - Emits [loadingState] before starting the search.
  /// - Emits [successState] if the search result is empty.
  /// - Emits [successSearchState] if the search result is not empty.
  ///
  /// Parameters:
  /// - `loadingState`: The state to emit while the search is being performed.
  /// - `successState`: The state to emit if the search result is empty.
  /// - `successSearchState`: The state to emit if the search result is not empty.
  /// - `performSearch`: A future that performs the search and returns a list of items.
  Future<void> searchForItems({
    required TState loadingState,
    required TState successState,
    required TState successSearchState,
    required Future<List<T>> performSearch,
  }) async {
    emit(loadingState);
    List<T> searchResult = await performSearch;
    emit(searchResult.isEmpty ? successState : successSearchState);
  }

  /// Handles the selection and deselection of multiple items in a list and updates
  /// the state of a delete button notifier based on the selection status.
  ///
  /// This method toggles the selection state of an item at a given index in the
  /// `selectedRows` list. If any item in the list is selected, the
  /// `showDeleteButtonNotifier` is set to `true`, otherwise it is set to `false`.
  ///
  /// Parameters:
  /// - `selectedRows`: A list of boolean values representing the selection state
  ///   of each item.
  /// - `index`: The index of the item to be toggled.
  /// - `selected`: The current selection state of the item (not used in the method).
  /// - `showDeleteButtonNotifier`: A [ValueNotifier] that controls the visibility
  ///   of the delete button based on the selection state.
  void onItemsMultiSelection(List<bool> selectedRows, int index, bool selected,
      ValueNotifier<bool> showDeleteButtonNotifier) {
    if (selectedRows.elementAt(index)) {
      selectedRows[index] = false;
    } else {
      selectedRows[index] = true;
    }

    if (selectedRows.any((element) => element)) {
      showDeleteButtonNotifier.value = true;
    } else {
      showDeleteButtonNotifier.value = false;
    }
  }

  /// Handles the success state by resetting the selection of rows and emitting the given success state.
  ///
  /// This method is asynchronous and performs the following actions:
  /// 1. Resets the `selectedRows` list to have the same length as `itemsList` with all values set to `false`.
  /// 2. Emits the provided `successState`.
  ///
  /// The method takes one parameter:
  /// - `successState` (`TState`): The state to be emitted upon successful handling.
  void _handleSuccess(TState successState) async {
    selectedRows = List.filled(itemsList.length, false);
    emit(successState);
  }

  /// Resets the `showDeleteButtonNotifier` to `false`.
  ///
  /// This method is used to hide the delete button by setting the
  /// `showDeleteButtonNotifier`'s value to `false`.
  void _resetShowDeleteButtonNotifier() {
    showDeleteButtonNotifier.value = false;
  }

  /// Retrieves the IDs of the selected items from the list of selected rows.
  ///
  /// Iterates through the `selectedRows` list and checks if each row is selected.
  /// If a row is selected, the corresponding item's ID from `itemsList` is added to the result list.
  ///
  /// Returns a list of IDs of the selected items.
  List<String> getSelectedItemsIds() {
    final List<String> itemsIds = [];
    for (int i = 0; i < selectedRows.length; i++) {
      if (selectedRows.elementAt(i)) {
        itemsIds.add(itemsList.elementAt(i)!.id);
      }
    }
    return itemsIds;
  }
}
