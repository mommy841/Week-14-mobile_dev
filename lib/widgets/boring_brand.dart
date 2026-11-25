import 'package:material_ui/material_ui.dart';

import '../theme/app_theme.dart';

class BoringBrand extends StatelessWidget {
  const BoringBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 132,
          height: 132,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 42,
                child: Container(
                  width: 48,
                  height: 48,
                  color: appInk,
                  alignment: Alignment.center,
                  child: Container(width: 28, height: 28, color: Colors.white),
                ),
              ),
              const Positioned(top: 63, left: 19, child: _PixelBlock()),
              const Positioned(top: 63, right: 19, child: _PixelBlock()),
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 132,
                  height: 48,
                  color: appInk,
                  alignment: Alignment.topCenter,
                  child: Container(width: 96, height: 34, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Boring App',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ],
    );
  }
}

class _PixelBlock extends StatelessWidget {
  const _PixelBlock();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 14,
        height: 14,
        child: ColoredBox(color: appInk),
      );
}
