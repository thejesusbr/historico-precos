# Histórico de Preços

Aplicativo Flutter para escanear notas fiscais e acompanhar o histórico de preços de produtos.

## Funcionalidades

- 📱 **Escaneamento de QR Code**: Leia o QR Code das notas fiscais para importar produtos automaticamente
- 🔥 **Integração Firebase**: Armazenamento seguro dos dados na nuvem
- 📊 **Histórico de Preços**: Acompanhe a evolução dos preços dos produtos ao longo do tempo
- 🏷️ **Categorização Automática**: Produtos são categorizados automaticamente (Alimentação, Bebidas, Limpeza, etc.)
- 📈 **Estatísticas**: Visualize gráficos e estatísticas das suas compras
- 🔍 **Busca Inteligente**: Encontre produtos por nome, categoria ou código de barras

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento mobile multiplataforma
- **Firebase**: Backend as a Service (Firestore, Authentication)
- **Riverpod**: Gerenciamento de estado
- **Mobile Scanner**: Leitura de QR Codes
- **FL Chart**: Gráficos e visualizações
- **Material Design 3**: Interface moderna e intuitiva

## Estrutura do Projeto

```
lib/
├── models/           # Modelos de dados (Product, NfeData, etc.)
├── screens/          # Telas da aplicação
├── services/         # Serviços (Firebase, NFe API)
├── providers/        # Providers do Riverpod
└── main.dart         # Ponto de entrada da aplicação
```

## Como Executar

1. **Pré-requisitos**:
   - Flutter SDK instalado
   - Conta Firebase configurada
   - Android Studio ou VS Code

2. **Instalação**:
   ```bash
   git clone https://github.com/thejesusbr/historico-precos.git
   cd historico-precos
   flutter pub get
   ```

3. **Configuração Firebase**:
   - Configure seu projeto Firebase
   - Atualize o arquivo `lib/firebase_options.dart` com suas credenciais
   - Adicione os arquivos `google-services.json` (Android) e `GoogleService-Info.plist` (iOS)

4. **Executar**:
   ```bash
   flutter run
   ```

## Organização dos Dados

Os produtos são organizados de duas formas:

- **Produtos Industrializados**: Identificados pelo código de barras
- **Produtos Variáveis**: Identificados pela descrição (ex: hortifruti, carnes)

Cada produto mantém um histórico completo de compras com:
- Data da compra
- Preço pago
- Quantidade
- Estabelecimento
- Chave da NFe

## Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
