class CameraData {
  final String text;
  String? imagePath;
  bool isLoading;
  final bool isMandatory;

  String get getText => text;
  String? get getImagePath => imagePath;
  bool get getIsLoading => isLoading;
  bool get getIsMandatory => isMandatory;

  set setImagePath(String? imagePath) => this.imagePath = imagePath;
  set setIsLoading(bool isLoading) => this.isLoading = isLoading;

  CameraData({
    required this.text,
    this.imagePath,
    this.isLoading = false,
    this.isMandatory = true,
  });

  void reset() {
    setImagePath = null;
    setIsLoading = false;
  }
}
