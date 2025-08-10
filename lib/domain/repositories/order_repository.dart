import '../../core/result/result.dart';
import '../entities/order.dart';

/// Repository interface for order-related operations
abstract class OrderRepository {
  /// Get all orders for a user
  Future<Result<List<Order>>> getUserOrders(String userId);

  /// Get order by ID
  Future<Result<Order>> getOrderById(String id);

  /// Get orders by status
  Future<Result<List<Order>>> getOrdersByStatus(String userId, OrderStatus status);

  /// Get orders by date range
  Future<Result<List<Order>>> getOrdersByDateRange(String userId, DateTime startDate, DateTime endDate);

  /// Create a new order
  Future<Result<Order>> createOrder(Order order);

  /// Update order status
  Future<Result<Order>> updateOrderStatus(String orderId, OrderStatus status);

  /// Cancel an order
  Future<Result<Order>> cancelOrder(String orderId);

  /// Get order history
  Future<Result<List<Order>>> getOrderHistory(String userId, {int limit = 50});

  /// Get active orders (pending, confirmed, preparing, ready)
  Future<Result<List<Order>>> getActiveOrders(String userId);

  /// Get order statistics for a user
  Future<Result<Map<String, dynamic>>> getOrderStatistics(String userId);

  /// Add order notes
  Future<Result<Order>> addOrderNotes(String orderId, String notes);

  /// Get orders for a specific date
  Future<Result<List<Order>>> getOrdersForDate(String userId, DateTime date);

  /// Get orders by slot (breakfast, lunch, dinner, snack)
  Future<Result<List<Order>>> getOrdersBySlot(String userId, OrderSlot slot);
}
