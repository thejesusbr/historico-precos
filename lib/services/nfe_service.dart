import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/nfe_data.dart';

final nfeServiceProvider = Provider<NfeService>((ref) => NfeService());

class NfeService {
  final Dio _dio = Dio();

  Future<NfeData?> fetchNfeData(String qrCodeData) async {
    try {
      final nfeKey = _extractNfeKey(qrCodeData);
      if (nfeKey == null) {
        throw Exception('QR Code inválido');
      }

      final response = await _dio.get(
        'https://www.nfe.fazenda.gov.br/portal/consultaRecaptcha.aspx',
        queryParameters: {
          'tipoConsulta': 'completa',
          'tipoConteudo': 'XML',
          'chNFe': nfeKey,
        },
      );

      if (response.statusCode == 200) {
        return _parseNfeResponse(response.data, nfeKey);
      } else {
        throw Exception('Erro ao consultar NFe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao processar NFe: $e');
    }
  }

  String? _extractNfeKey(String qrCodeData) {
    final uri = Uri.tryParse(qrCodeData);
    if (uri == null) return null;

    final chNFe = uri.queryParameters['chNFe'];
    if (chNFe != null && chNFe.length == 44) {
      return chNFe;
    }

    final regex = RegExp(r'chNFe=([0-9]{44})');
    final match = regex.firstMatch(qrCodeData);
    return match?.group(1);
  }

  NfeData _parseNfeResponse(dynamic responseData, String nfeKey) {
    return NfeData(
      key: nfeKey,
      cnpj: '00.000.000/0000-00',
      storeName: 'Estabelecimento Exemplo',
      issueDate: DateTime.now(),
      totalValue: 0.0,
      items: [
        NfeItem(
          code: '001',
          name: 'Produto Exemplo',
          barcode: '7891234567890',
          quantity: 1.0,
          unit: 'un',
          unitPrice: 10.00,
          totalPrice: 10.00,
        ),
      ],
    );
  }
}
