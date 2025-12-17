class ApiResponse<T> {
  final String status;
  final T data;

  ApiResponse({required this.status, required this.data});
}
