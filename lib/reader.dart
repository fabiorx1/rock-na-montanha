import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rock_qrcode/codes.dart';

class QrCodeReader extends StatefulWidget {
  const QrCodeReader({Key? key}) : super(key: key);

  @override
  State<QrCodeReader> createState() => _QrCodeReaderState();
}

class _QrCodeReaderState extends State<QrCodeReader> {
  bool leu = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leitor de QR-Code')),
      body: Stack(
        children: [
          MobileScanner(
            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Não foi possível ler o QR-Code.',
                              style: TextStyle(fontSize: 21),
                            ),
                          ),
                          Material(
                            elevation: 12,
                            color: Colors.black,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Tentar Novamente',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).then((value) => Navigator.pop(context));
                Navigator.pop(context);
              } else {
                setState(
                  () {
                    leu = true;
                  },
                );
                final String qrCodeInfo = barcode.rawValue!;
                final pieces = qrCodeInfo.split(' ');
                var code = pieces.last;
                code = code.substring(max(0, code.length - 11));
                String text = '';
                Color color = Colors.black;
                if (codes.contains(code)) {
                  if (verifiedCodes.contains(code)) {
                    text = 'Qr-Code já usado!';
                    color = Colors.red;
                  } else {
                    text = 'Qr-Code Válido!\nEntrada Liberada';
                    color = Colors.green;
                    verifiedCodes.add(code);
                  }
                } else {
                  text = 'Qr-Code Inválido!';
                  color = Colors.red;
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 21),
                          ),
                          Icon(
                            Icons.circle,
                            color: color,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                    );
                  },
                ).then((_) {
                  setState(
                    () {
                      leu = false;
                    },
                  );
                });
              }
            },
          ),
          Positioned(
              bottom: 12,
              child: Material(
                color: leu ? Colors.green.shade200 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    leu ? 'Lido! Verificando...' : 'Tentando ler...',
                    style: const TextStyle(fontSize: 21),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
