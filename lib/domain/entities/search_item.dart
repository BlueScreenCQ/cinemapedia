class SearchItem {
  final int sId;
  final String sImage;
  final String sName;
  final String sText;
  final DateTime? sDate;

  final bool isPeli;
  final bool isTV;
  final bool isActor;

  SearchItem({required this.sId, required this.sName, required this.sImage, required this.sText, required this.sDate, this.isPeli = false, this.isTV = false, this.isActor = false});
}
