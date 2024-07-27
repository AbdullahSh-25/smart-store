import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrCodeScanner extends StatefulWidget {
  // final QRViewController controller;
  const QrCodeScanner({Key? key/*, required this.controller*/}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? _controller;



  @override
  Widget build(BuildContext context) {
    print('qr scanner');
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller){
        controller.scannedDataStream.listen((value) {
          _controller  = controller;
          if(value.code!.isNotEmpty){
            print('Qr value');
            print(value.code);
          }
        });
        controller.pauseCamera();
      },
    );
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}