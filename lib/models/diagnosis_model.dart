class DiagnosisModel {
  final String prediction;
  final String confidence;
  final String description;
  final String recommendation;
  final String top3;

  DiagnosisModel({
    required this.prediction,
    required this.confidence,
    required this.description,
    required this.recommendation,
    required this.top3,
  });

  factory DiagnosisModel.fromGradio(List<dynamic> data) {
    return DiagnosisModel(
      prediction: data[0].toString(),

      confidence: data[1].toString(),

      description: data[2].toString(),

      recommendation: data[3].toString(),

      top3: data[4].toString(),
    );
  }
}
