import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/nfe_data.dart';
import '../services/firebase_service.dart';

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  () => ProductsNotifier(),
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final firebaseService = ref.read(firebaseServiceProvider);
    return await firebaseService.getProducts();
  }

  Future<void> addPurchasesFromNfe(NfeData nfeData) async {
    final firebaseService = ref.read(firebaseServiceProvider);
    
    for (final item in nfeData.items) {
      final purchaseRecord = PurchaseRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        price: item.totalPrice,
        quantity: item.quantity,
        unit: item.unit,
        date: nfeData.issueDate,
        store: nfeData.storeName,
        nfeKey: nfeData.key,
        notes: null,
      );

      Product? existingProduct;
      
      if (item.barcode != null && item.barcode!.isNotEmpty) {
        existingProduct = await firebaseService.getProductByBarcode(item.barcode!);
      } else {
        existingProduct = await firebaseService.getProductByName(item.name);
      }

      if (existingProduct != null) {
        final updatedPurchases = [...existingProduct.purchases, purchaseRecord];
        final updatedProduct = existingProduct.copyWith(
          purchases: updatedPurchases,
          updatedAt: DateTime.now(),
        );
        await firebaseService.updateProduct(updatedProduct);
      } else {
        final newProduct = Product(
          id: '',
          name: item.name,
          barcode: item.barcode,
          description: null,
          category: _categorizeProduct(item.name),
          purchases: [purchaseRecord],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await firebaseService.addProduct(newProduct);
      }
    }

    ref.invalidateSelf();
  }

  String _categorizeProduct(String productName) {
    final name = productName.toLowerCase();
    
    if (name.contains('leite') || name.contains('queijo') || name.contains('iogurte') ||
        name.contains('manteiga') || name.contains('pão') || name.contains('arroz') ||
        name.contains('feijão') || name.contains('macarrão') || name.contains('açúcar') ||
        name.contains('sal') || name.contains('óleo') || name.contains('farinha')) {
      return 'Alimentação';
    }
    
    if (name.contains('refrigerante') || name.contains('suco') || name.contains('água') ||
        name.contains('cerveja') || name.contains('vinho') || name.contains('café')) {
      return 'Bebidas';
    }
    
    if (name.contains('detergente') || name.contains('sabão') || name.contains('amaciante') ||
        name.contains('desinfetante') || name.contains('álcool') || name.contains('papel higiênico')) {
      return 'Limpeza';
    }
    
    if (name.contains('shampoo') || name.contains('condicionador') || name.contains('sabonete') ||
        name.contains('pasta de dente') || name.contains('desodorante') || name.contains('perfume')) {
      return 'Higiene';
    }
    
    return 'Outros';
  }

  Future<void> deleteProduct(String productId) async {
    final firebaseService = ref.read(firebaseServiceProvider);
    await firebaseService.deleteProduct(productId);
    ref.invalidateSelf();
  }

  Future<void> updateProduct(Product product) async {
    final firebaseService = ref.read(firebaseServiceProvider);
    await firebaseService.updateProduct(product);
    ref.invalidateSelf();
  }
}
