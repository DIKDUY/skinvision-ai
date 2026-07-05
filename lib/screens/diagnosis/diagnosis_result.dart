class DiagnosisResult {

  final String disease;
  final double confidence;

  DiagnosisResult({
    required this.disease,
    required this.confidence,
  });

  factory DiagnosisResult.fromJson(
      Map<String, dynamic> json) {

    return DiagnosisResult(
      disease: json['disease'],
      confidence:
          json['confidence'].toDouble(),
    );
  }
}