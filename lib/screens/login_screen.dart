import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:smart_store/core/utils/context_extensions.dart';
import 'package:smart_store/screens/home_screen.dart';

import '../widgets/qr_scanner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E2E2),
                  borderRadius: BorderRadius.circular(16),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'امسح الرمز التعريفي الخاص بك',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 15,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                      ),
                      const Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          'قم بالتسجيل بخطوة واحدة فقط!',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushReplacement(const HomeScreen());
                    },
                    child: SizedBox(
                      width: context.fullWidth * 0.7,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CustomPaint(
                          foregroundPainter: RectangleCorner(),
                          child: AnimatedCrossFade(
                            firstChild: Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.qr_code_2_rounded,
                                    color: const Color(0xF53B3B3B),
                                    size: context.fullWidth * 0.65,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    height: 5,
                                    width: context.fullWidth * 0.65,
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ).animate(onComplete: (controller) {
                                    controller.repeat(reverse: true);
                                  }).slideY(duration: const Duration(seconds: 2), begin: 25, end: -25),
                                )
                              ],
                            ),
                            secondChild: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: context.fullWidth * 0.65,
                                  height: context.fullWidth * 0.65,
                                  child: const QrCodeScanner(),
                                ),
                              ),
                            ),
                            crossFadeState: _crossFadeState,
                            duration: const Duration(milliseconds: 500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_crossFadeState == CrossFadeState.showFirst) {
                      _crossFadeState = CrossFadeState.showSecond;
                    } else {
                      _crossFadeState = CrossFadeState.showFirst;
                    }
                  });
                },
                child: const Text('امسح', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RectangleCorner extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width;
    final y = size.height;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path();
    //top left
    path.moveTo(x * 0.1, 0);
    path.lineTo(x * 0.05, 0);
    path.quadraticBezierTo(0, 0, 0, y * 0.05);
    path.lineTo(0, y * 0.1);
    //top right
    path.moveTo(x * 0.9, 0);
    path.lineTo(x * 0.95, 0);
    path.quadraticBezierTo(x, 0, x, y * 0.05);
    path.lineTo(x, y * 0.1);
    //bottom right
    path.moveTo(x, y * 0.9);
    path.lineTo(x, y * 0.95);
    path.quadraticBezierTo(x, y, x * 0.95, y);
    path.lineTo(x * 0.9, y);
    //bottom left
    path.moveTo(x * 0.1, y);
    path.lineTo(x * 0.05, y);
    path.quadraticBezierTo(0, y, 0, y * 0.95);
    path.lineTo(0, y * 0.9);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
