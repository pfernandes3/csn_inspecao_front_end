class Item {
  final int id;
  final String descricao;
  final String localInspecao;
  final String TAG;
  final String REF;
  final bool CR;
  final bool SB;
  final bool MD;
  final bool DE;
  final bool AC;
  final double nivelRisco;
  final String registroInicial;
  final String? registroFinal;

  Item(
      this.id,
      this.descricao,
      this.localInspecao,
      this.TAG,
      this.REF,
      this.CR,
      this.SB,
      this.MD,
      this.DE,
      this.AC,
      this.nivelRisco,
      this.registroInicial,
      this.registroFinal);
}
