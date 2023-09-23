extension ToMyCurrency on double {
  String toMyCurrency([int? int]) {
    return toStringAsFixed(int ?? 2).replaceAll('.', ',').replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );
  }
}
