# Guia de Configuração do Firebase - Histórico Preços

Este guia irá ajudá-lo a configurar o Firebase do zero para o projeto Histórico Preços.

## Pré-requisitos
- Conta Google
- Projeto Flutter funcionando (build Android já resolvido)
- Acesso ao [Firebase Console](https://console.firebase.google.com)

## Passo 1: Criar Projeto Firebase

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Faça login com sua conta Google
3. Clique em **"Criar um projeto"** ou **"Adicionar projeto"**
4. Digite o nome do projeto: `historico-precos`
5. **Desabilite** o Google Analytics (opcional para este projeto)
6. Clique em **"Criar projeto"**
7. Aguarde a criação do projeto

## Passo 2: Adicionar App Android ao Projeto

1. No Firebase Console, clique em **"Adicionar app"** e selecione **Android**
2. Preencha os campos:
   - **Nome do pacote Android**: `com.historicoprecos.historico_precos`
   - **Apelido do app**: `Historico Precos Android`
   - **SHA-1**: deixe vazio por enquanto (pode adicionar depois para produção)
3. Clique em **"Registrar app"**

## Passo 3: Baixar e Instalar google-services.json

1. Baixe o arquivo `google-services.json` do Firebase Console
2. **IMPORTANTE**: Coloque o arquivo em `android/app/google-services.json`
3. **NÃO COMMITE** este arquivo no git (contém credenciais sensíveis)
4. Verifique se o arquivo contém suas credenciais reais do projeto

## Passo 4: Habilitar Firestore Database

1. No Firebase Console, vá para **"Firestore Database"**
2. Clique em **"Criar banco de dados"**
3. Escolha **"Começar no modo de teste"** (permite leitura/escrita por 30 dias)
4. Selecione uma localização (escolha a mais próxima dos seus usuários)
5. Clique em **"Concluído"**

## Passo 5: Atualizar Firebase Options com Credenciais Reais

1. No Firebase Console, vá para **Configurações do projeto** (ícone de engrenagem)
2. Role para baixo até a seção **"Seus apps"**
3. Copie os valores de configuração para o app Android
4. Atualize o arquivo `lib/firebase_options.dart` com os valores reais:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'SUA_API_KEY_ANDROID_REAL',
  appId: 'SEU_APP_ID_ANDROID_REAL', 
  messagingSenderId: 'SEU_SENDER_ID_REAL',
  projectId: 'historico-precos',
  storageBucket: 'historico-precos.appspot.com',
);
```

**Substitua os valores placeholder pelos valores reais do Firebase Console.**

## Passo 6: Configurar Regras de Segurança do Firestore

1. No Firebase Console, vá para **"Firestore Database"** → **"Regras"**
2. Substitua as regras padrão por regras amigáveis para desenvolvimento:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{document} {
      allow read, write: if true; // Apenas para desenvolvimento
    }
  }
}
```

3. Clique em **"Publicar"**

⚠️ **ATENÇÃO**: Essas regras são apenas para desenvolvimento. Para produção, implemente regras de segurança adequadas.

## Passo 7: Testar Integração Firebase Localmente

1. Execute os comandos:
```bash
flutter clean
flutter pub get
```

2. Teste a versão web primeiro:
```bash
flutter run -d chrome
```

3. Verifique se não há erros de conexão Firebase no console
4. Teste criar um produto para verificar se as operações de escrita no Firestore funcionam

## Passo 8: Testar Build Android com Firebase

1. Execute o build Android:
```bash
flutter build apk --debug
```

2. Verifique se o build completa sem erros relacionados ao Firebase
3. Se tiver emulador Android, teste a funcionalidade do app

## Passo 9: Verificar Operações do Firestore

1. Acesse Firebase Console → Firestore Database
2. Verifique se a coleção `products` aparece quando você usar o app
3. Confirme se os dados estão sendo escritos e lidos corretamente

## Passo 10: Atualizar .gitignore (se necessário)

Verifique se estes arquivos estão no `.gitignore`:
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

Isso previne o commit de credenciais sensíveis do Firebase.

## Notas de Segurança

- **NUNCA** commite `google-services.json` ou `GoogleService-Info.plist` no git
- O arquivo `firebase_options.dart` pode ser commitado (contém configuração pública)
- Comece com regras de teste do Firestore para desenvolvimento
- Considere adicionar fingerprints SHA-1 para builds de produção

## Solução de Problemas

### Erro "Default FirebaseApp is not initialized"
- Verifique se `Firebase.initializeApp()` é chamado no `main()`
- Confirme se o arquivo `google-services.json` está no local correto

### Operações do Firestore falham
- Verifique se o banco de dados foi criado
- Confirme se as regras permitem acesso
- Verifique a conexão com a internet

### Build Android falha
- Verifique se `google-services.json` está em `android/app/`
- Confirme se o nome do pacote está correto
- Execute `flutter clean` e tente novamente

## Próximos Passos Após Configuração

1. **Configurar regras de segurança de produção** para o Firestore
2. **Adicionar configuração iOS** se necessário (`GoogleService-Info.plist`)
3. **Adicionar configuração web** se for fazer deploy para web
4. **Configurar Firebase Authentication** se precisar de contas de usuário

## Estrutura Atual do Projeto

O projeto já está configurado para usar:
- ✅ `firebase_core` - Inicialização do Firebase
- ✅ `cloud_firestore` - Banco de dados Firestore
- ✅ `firebase_auth` - Autenticação (importado mas não usado atualmente)

## Suporte

Se encontrar problemas durante a configuração:
1. Verifique se seguiu todos os passos na ordem
2. Confirme se os arquivos estão nos locais corretos
3. Verifique se as credenciais foram copiadas corretamente
4. Execute `flutter doctor` para verificar problemas de ambiente

---

**Importante**: Este guia configura o Firebase para desenvolvimento. Para produção, implemente regras de segurança adequadas e configure autenticação se necessário.
