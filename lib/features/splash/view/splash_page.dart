import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bgFade; // fades in the background image
  late final Animation<double> _logoFade; // fades in the logo image
  late final Animation<double> _logoScale; // pops the logo
  late final Animation<double> _logoRotate; // slight rotation for flair

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bgFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
    );

    _logoFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );

    _logoRotate = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _ctrl.forward();

    // when done, navigate
    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              FadeTransition(
                opacity: _bgFade,
                child: Image.asset(
                  'assets/images/splash_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _logoFade,
                  child: ScaleTransition(
                    scale: _logoScale,
                    child: RotationTransition(
                      turns: _logoRotate,
                      child: Image.asset(
                        'assets/images/splash_logo.png',
                        width: 160,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
