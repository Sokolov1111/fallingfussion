import 'package:fallingfusion/logic/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlButtons extends ConsumerWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GameButton(
            icon: Icons.arrow_left_rounded,
            onTap: controller.moveLeft,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 24),
          _FastDropButton(controller: controller),
          const SizedBox(width: 24),
          _GameButton(
            icon: Icons.arrow_right_rounded,
            onTap: controller.moveRight,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }
}

class _GameButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _GameButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  State<_GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<_GameButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 2);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (d) {
        _onTapUp(d);
        widget.onTap();
      },
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 60),
        ),
      ),
    );
  }
}

class _FastDropButton extends StatefulWidget {
  final dynamic controller;

  const _FastDropButton({required this.controller});

  @override
  State<_FastDropButton> createState() => _FastDropButtonState();
}

class _FastDropButtonState extends State<_FastDropButton> {
  double _scale = 1.0;

  void _handleDown(TapDownDetails d) {
    setState(() => _scale = 1.7);
    widget.controller.setFastDrop(true);
  }

  void _handleUp(TapUpDetails d) {
    setState(() => _scale = 1.0);
    widget.controller.setFastDrop(false);
  }

  void _handleCancel() {
    setState(() => _scale = 1.0);
    widget.controller.setFastDrop(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleDown,
      onTapUp: _handleUp,
      onTapCancel: _handleCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: Colors.greenAccent.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withOpacity(0.6),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.arrow_downward_rounded,
              color: Colors.white, size: 60),
        ),
      ),
    );
  }
}
