class PagedResponse<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;

  PagedResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
  });

  factory PagedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PagedResponse<T>(
      content: (json['content'] as List).map(fromJsonT).toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }

  List<T> get items => content;
}
