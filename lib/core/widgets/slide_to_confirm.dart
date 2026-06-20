import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

class SlideToConfirm extends StatefulWidget {
  final VoidCallback onConfirm;
  final String text;

  const SlideToConfirm({
    super.key,
    required this.onConfirm,
    this.text = 'Geser untuk memilih',
  });

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;

  static const double _height = 56.0;
  static const double _thumbSize = 50.0;
  static const double _padding = 3.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isConfirmed) return;

    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) {
        _dragPosition = 0;
      }
      final maxDrag = maxWidth - _thumbSize - (_padding * 2);
      if (_dragPosition >= maxDrag) {
        _dragPosition = maxDrag;
        _isConfirmed = true;
        widget.onConfirm();
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double maxWidth) {
    if (_isConfirmed) return;

    final maxDrag = maxWidth - _thumbSize - (_padding * 2);
    if (_dragPosition < maxDrag) {
      setState(() {
        _dragPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return Container(
          height: _height,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(_height / 2),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background Text
              Center(
                child: Text(
                  widget.text,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.outline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Draggable Thumb
              AnimatedPositioned(
                duration: _dragPosition == 0.0
                    ? const Duration(milliseconds: 300)
                    : Duration.zero,
                curve: Curves.easeOutBack,
                left: _padding + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onHorizontalDragUpdate(details, maxWidth),
                  onHorizontalDragEnd: (details) =>
                      _onHorizontalDragEnd(details, maxWidth),
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: AppColors.goldDark,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldMid.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
