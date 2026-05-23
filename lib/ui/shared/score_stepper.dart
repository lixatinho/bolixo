import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/bolixo_colors.dart';

/// A compact +/- score stepper optimized for mobile and web.
/// Supports tap and long-press for fast increment/decrement.
class ScoreStepper extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final bool enabled;
  final int maxValue;

  const ScoreStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.maxValue = 99,
  });

  @override
  State<ScoreStepper> createState() => _ScoreStepperState();
}

class _ScoreStepperState extends State<ScoreStepper> {
  late int _value;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(ScoreStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _increment() {
    if (!widget.enabled || _value >= widget.maxValue) return;
    HapticFeedback.lightImpact();
    setState(() => _value++);
    widget.onChanged(_value);
  }

  void _decrement() {
    if (!widget.enabled || _value <= 0) return;
    HapticFeedback.lightImpact();
    setState(() => _value--);
    widget.onChanged(_value);
  }

  void _startRepeat(VoidCallback action) {
    action();
    _timer = Timer.periodic(const Duration(milliseconds: 150), (_) => action());
  }

  void _stopRepeat() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    final opacity = widget.enabled ? 1.0 : 0.4;
    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.keyboard_arrow_up_rounded,
            onTap: _increment,
            onLongStart: () => _startRepeat(_increment),
            enabled: widget.enabled && _value < widget.maxValue,
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 48,
            height: 44,
            child: Center(
              child: Text(
                '$_value',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: BolixoColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          _buildButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onTap: _decrement,
            onLongStart: () => _startRepeat(_decrement),
            enabled: widget.enabled && _value > 0,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required VoidCallback onLongStart,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      onLongPressStart: enabled ? (_) => onLongStart() : null,
      onLongPressEnd: enabled ? (_) => _stopRepeat() : null,
      onLongPressCancel: enabled ? _stopRepeat : null,
      child: Tooltip(
        message: icon == Icons.keyboard_arrow_up_rounded ? '+1' : '-1',
        child: SizedBox(
          width: 48,
          height: 28,
          child: Icon(
            icon,
            size: 22,
            color: enabled
                ? BolixoColors.accentGreen
                : BolixoColors.textTertiary.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
