import 'package:flutter/material.dart';

class CustomSwitchWidget extends StatelessWidget {
  const CustomSwitchWidget({
    super.key,
    required this.value,
    this.materialTapTargetSize = MaterialTapTargetSize.padded,
    required this.onChanged,
  });
  final bool value;
  final MaterialTapTargetSize materialTapTargetSize;
  final void Function(bool) onChanged;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Switch(
      value: value,
      materialTapTargetSize: materialTapTargetSize,
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
        (Set<WidgetState> states) => states.contains(WidgetState.selected)
            ? const Icon(Icons.check, color: Colors.white)
            : const Icon(Icons.close, color: Colors.white),
      ),
      activeColor: colorScheme.secondary,
      activeTrackColor: colorScheme.secondaryContainer,
      inactiveThumbColor: Colors.red.withValues(alpha: 0.9),
      inactiveTrackColor: colorScheme.secondaryContainer,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      onChanged: onChanged,
    );
  }
}
