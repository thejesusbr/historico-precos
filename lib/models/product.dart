import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String? barcode;
  final String? description;
  final String category;
  final List<PurchaseRecord> purchases;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.barcode,
    this.description,
    required this.category,
    required this.purchases,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      barcode: data['barcode'],
      description: data['description'],
      category: data['category'] ?? 'Outros',
      purchases: (data['purchases'] as List<dynamic>?)
              ?.map((p) => PurchaseRecord.fromMap(p))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'barcode': barcode,
      'description': description,
      'category': category,
      'purchases': purchases.map((p) => p.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? barcode,
    String? description,
    String? category,
    List<PurchaseRecord>? purchases,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      category: category ?? this.category,
      purchases: purchases ?? this.purchases,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get averagePrice {
    if (purchases.isEmpty) return 0.0;
    final total = purchases.fold<double>(0.0, (total, p) => total + p.price);
    return total / purchases.length;
  }

  double get lowestPrice {
    if (purchases.isEmpty) return 0.0;
    return purchases.map((p) => p.price).reduce((a, b) => a < b ? a : b);
  }

  double get highestPrice {
    if (purchases.isEmpty) return 0.0;
    return purchases.map((p) => p.price).reduce((a, b) => a > b ? a : b);
  }

  int get totalPurchases => purchases.length;

  PurchaseRecord? get lastPurchase {
    if (purchases.isEmpty) return null;
    return purchases.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }
}

class PurchaseRecord {
  final String id;
  final double price;
  final double quantity;
  final String unit;
  final DateTime date;
  final String store;
  final String? nfeKey;
  final String? notes;

  PurchaseRecord({
    required this.id,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.date,
    required this.store,
    this.nfeKey,
    this.notes,
  });

  factory PurchaseRecord.fromMap(Map<String, dynamic> map) {
    return PurchaseRecord(
      id: map['id'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: (map['quantity'] ?? 1.0).toDouble(),
      unit: map['unit'] ?? 'un',
      date: (map['date'] as Timestamp).toDate(),
      store: map['store'] ?? '',
      nfeKey: map['nfeKey'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'date': Timestamp.fromDate(date),
      'store': store,
      'nfeKey': nfeKey,
      'notes': notes,
    };
  }

  double get unitPrice => quantity > 0 ? price / quantity : price;
}
