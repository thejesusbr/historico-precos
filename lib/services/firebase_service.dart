import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) => FirebaseService());

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _productsCollection = 'products';

  Future<List<Product>> getProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar produtos: $e');
    }
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('barcode', isEqualTo: barcode)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Product.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar produto por código de barras: $e');
    }
  }

  Future<Product?> getProductByName(String name) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Product.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao buscar produto por nome: $e');
    }
  }

  Future<String> addProduct(Product product) async {
    try {
      final docRef = await _firestore
          .collection(_productsCollection)
          .add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar produto: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection(_productsCollection)
          .doc(product.id)
          .update(product.toFirestore());
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(_productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_productsCollection)
          .where('category', isEqualTo: category)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar produtos por categoria: $e');
    }
  }
}
