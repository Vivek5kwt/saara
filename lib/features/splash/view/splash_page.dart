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
  late final Animation<double> _bgFade;    // fades in the logo image
  late final Animation<double> _logoScale; // pops the logo/text

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // from 0 → 1 over full duration
    _bgFade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    );

    // scale from 0.8 → 1.1 with a bounce
    _logoScale = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
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
              // first your static purple background
              Image.asset(
                'assets/images/splash_bg.png',
                fit: BoxFit.cover,
              ),

              // then fade in the logo-overlay image
              Opacity(
                opacity: _bgFade.value,
                child: Image.asset(
                  'assets/images/splash_logo.png',
                  fit: BoxFit.cover,
                ),
              ),

              // finally center your brand/logo text popping in
              Center(
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      // if you have a separate SVG or PNG icon, swap this out
                      Icon(Icons.self_improvement,
                          size: 80, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'Saara',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
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
