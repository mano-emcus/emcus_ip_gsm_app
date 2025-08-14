import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class GenericFormCard extends StatelessWidget {
  const GenericFormCard({super.key, this.padding, this.child});

  final EdgeInsets? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: padding ?? EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: customColors.themeSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
