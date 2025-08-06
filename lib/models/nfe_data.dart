class NfeData {
  final String key;
  final String cnpj;
  final String storeName;
  final DateTime issueDate;
  final double totalValue;
  final List<NfeItem> items;

  NfeData({
    required this.key,
    required this.cnpj,
    required this.storeName,
    required this.issueDate,
    required this.totalValue,
    required this.items,
  });

  factory NfeData.fromJson(Map<String, dynamic> json) {
    return NfeData(
      key: json['chave'] ?? '',
      cnpj: json['cnpj'] ?? '',
      storeName: json['nomeEmitente'] ?? '',
      issueDate: DateTime.parse(json['dataEmissao'] ?? DateTime.now().toIso8601String()),
      totalValue: (json['valorTotal'] ?? 0.0).toDouble(),
      items: (json['itens'] as List<dynamic>?)
              ?.map((item) => NfeItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class NfeItem {
  final String code;
  final String name;
  final String? barcode;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  NfeItem({
    required this.code,
    required this.name,
    this.barcode,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory NfeItem.fromJson(Map<String, dynamic> json) {
    return NfeItem(
      code: json['codigo'] ?? '',
      name: json['descricao'] ?? '',
      barcode: json['codigoBarras'],
      quantity: (json['quantidade'] ?? 1.0).toDouble(),
      unit: json['unidade'] ?? 'un',
      unitPrice: (json['valorUnitario'] ?? 0.0).toDouble(),
      totalPrice: (json['valorTotal'] ?? 0.0).toDouble(),
    );
  }
}
