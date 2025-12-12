import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:messenger/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AuthWrapper(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DotLottieLoader.fromNetwork(
          "https://lottie.host/fc86cd24-fe99-4fb8-9eb3-2b42f43d81d8/stqxc7dVuG.lottie",
          frameBuilder: (context, dotlottie) {
            if (dotlottie != null) {
              return Lottie.memory(
                dotlottie.animations.values.first,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                repeat: true,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                errorBuilder: (context, error, stackTrace) {
                  _controller.status == AnimationStatus.completed;
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send_rounded,
                        size: 100,
                        color: Colors.white,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Какая то фигня с анимацией",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
