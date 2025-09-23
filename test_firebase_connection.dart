import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado com sucesso!');
    
    // Teste de conexão com Firestore
    final firestore = FirebaseFirestore.instance;
    
    // Tenta ler a coleção products
    print('🔍 Testando conexão com Firestore...');
    final snapshot = await firestore.collection('products').limit(1).get();
    print('✅ Conexão com Firestore funcionando! Documentos encontrados: ${snapshot.docs.length}');
    
    // Teste de escrita (cria um documento de teste)
    print('📝 Testando escrita no Firestore...');
    await firestore.collection('products').add({
      'name': 'Produto de Teste Firebase',
      'barcode': 'TEST123',
      'category': 'Teste',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'purchases': [],
    });
    print('✅ Escrita no Firestore funcionando!');
    
    print('\n🎉 Todos os testes do Firebase passaram!');
    print('Seu Firebase está configurado corretamente.');
    
  } catch (e) {
    print('❌ Erro na configuração do Firebase:');
    print(e.toString());
    print('\nVerifique:');
    print('1. Se o arquivo google-services.json está em android/app/');
    print('2. Se as credenciais em firebase_options.dart estão corretas');
    print('3. Se o Firestore Database foi criado no Firebase Console');
    print('4. Se as regras do Firestore permitem leitura/escrita');
  }
}
