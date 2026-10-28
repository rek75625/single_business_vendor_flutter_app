class ApiConfig {
  static const String baseUrl = 'https://api.example.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Products
  static const String products = '/products';
  static const String categories = '/categories';
  static const String productDetails = '/products/{id}';

  // Cart
  static const String cart = '/cart';
  static const String cartAdd = '/cart/add';
  static const String cartUpdate = '/cart/update';
  static const String cartRemove = '/cart/remove';

  // Orders
  static const String orders = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String placeOrder = '/orders/place';

  // Favorites
  static const String favorites = '/favorites';
  static const String favoritesToggle = '/favorites/toggle';

  // Notifications
  static const String notifications = '/notifications';

  // Support
  static const String supportTickets = '/support/tickets';

  static String withId(String endpoint, String id) =>
      endpoint.replaceAll('{id}', id);
}
