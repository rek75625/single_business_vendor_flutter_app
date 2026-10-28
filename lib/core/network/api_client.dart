class ApiResponse<T> {
  final T? data;
  final bool success;
  final String message;
  final int statusCode;

  ApiResponse({
    this.data,
    required this.success,
    required this.message,
    required this.statusCode,
  });
}

abstract class ApiClient {
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  });

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  });

  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  });

  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  });
}

class MockApiClient implements ApiClient {
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    await _simulateDelay();
    return ApiResponse<T>(
      data: null,
      success: true,
      message: 'Success',
      statusCode: 200,
    );
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    await _simulateDelay();
    return ApiResponse<T>(
      data: null,
      success: true,
      message: 'Created',
      statusCode: 201,
    );
  }

  @override
  Future<ApiResponse<T>> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    await _simulateDelay();
    return ApiResponse<T>(
      data: null,
      success: true,
      message: 'Updated',
      statusCode: 200,
    );
  }

  @override
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    await _simulateDelay();
    return ApiResponse<T>(
      data: null,
      success: true,
      message: 'Deleted',
      statusCode: 204,
    );
  }
}
