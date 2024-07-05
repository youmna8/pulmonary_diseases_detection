class ReportResponse {
  final String result;
  final String patientId;
  final DateTime updatedAt;
  final DateTime createdAt;
  final int id;

  ReportResponse({
    required this.result,
    required this.patientId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    return ReportResponse(
      result: json['result'],
      patientId: json['patient_id'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      id: json['id'],
    );
  }
}
