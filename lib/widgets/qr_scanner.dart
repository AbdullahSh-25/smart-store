import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_store/core/utils/context_extensions.dart';

import '../core/constants/app_keys.dart';
import '../screens/home_screen.dart';


class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

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
        controller.scannedDataStream.listen((value) async {
          _controller  = controller;
          if(value.code!.isNotEmpty){
            print('Qr value');
            print(value.code);
            await Hive.box(AppKeys.box).put(AppKeys.token, value.code).then((value) {
              context.pushReplacement(const HomeScreen());
              controller.pauseCamera();
            });
          }
        });
      },
    );
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}