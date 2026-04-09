import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.goNamed('home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Stack(
          children: [
            // Texto Foodgo centrado
            Center(
              child: Text(
                'Foodgo',
                style: GoogleFonts.lobster(
                  fontSize: 70,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Imágenes de Burgers en la parte inferior izquierda
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Burger grande (atrás)
                    Positioned(
                      bottom: 0,
                      left: -20,
                      child: Image.asset(
                        'assets/images/burger_triple.png',
                        width: MediaQuery.of(context).size.width * 0.45,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      ),
                    ),
                    // Burger pequeña (adelante)
                    Positioned(
                      bottom: 0,
                      left: 100,
                      child: Image.asset(
                        'assets/images/burger_normal.png',
                        width: MediaQuery.of(context).size.width * 0.35,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
