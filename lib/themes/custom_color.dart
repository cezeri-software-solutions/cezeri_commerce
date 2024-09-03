import 'package:flutter/material.dart';

extension GetCustomColors on BuildContext {
  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
}

// CustomColors lightCustomColors = const CustomColors(
//   sourceNeutralvariant: sourceNeutralvariant,
//   neutralvariant: neutralvariant,
//   onNeutralvariant: onNeutralvariant,
//   neutralvariantContainer: neutralvariantContainer,
//   onNeutralvariantContainer: onNeutralvariantContainer,
//   sourceDecorative: sourceDecorative,
//   decorative: decorative,
//   onDecorative: onDecorative,
//   decorativeContainer: decorativeContainer,
//   onDecorativeContainer: onDecorativeContainer,
//   sourceDecorative2: sourceDecorative2,
//   decorative2: decorative2,
//   onDecorative2: onDecorative2,
//   decorative2Container: decorative2Container,
//   onDecorative2Container: onDecorative2Container,
//   sourceError: sourceError,
//   error: error,
//   onError: onError,
//   errorContainer: errorContainer,
//   onErrorContainer: onErrorContainer,
//   sourceWarning: sourceWarning,
//   warning: warning,
//   onWarning: onWarning,
//   warningContainer: warningContainer,
//   onWarningContainer: onWarningContainer,
//   sourceSuccess: sourceSuccess,
//   success: success,
//   onSuccess: onSuccess,
//   successContainer: successContainer,
//   onSuccessContainer: onSuccessContainer,
// );

/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceNeutralvariant,
    required this.neutralvariant,
    required this.onNeutralvariant,
    required this.neutralvariantContainer,
    required this.onNeutralvariantContainer,
    required this.sourceDecorative,
    required this.decorative,
    required this.onDecorative,
    required this.decorativeContainer,
    required this.onDecorativeContainer,
    required this.sourceDecorative2,
    required this.decorative2,
    required this.onDecorative2,
    required this.decorative2Container,
    required this.onDecorative2Container,
    required this.sourceError,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.sourceWarning,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.sourceSuccess,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
  });

  final Color? sourceNeutralvariant;
  final Color? neutralvariant;
  final Color? onNeutralvariant;
  final Color? neutralvariantContainer;
  final Color? onNeutralvariantContainer;
  final Color? sourceDecorative;
  final Color? decorative;
  final Color? onDecorative;
  final Color? decorativeContainer;
  final Color? onDecorativeContainer;
  final Color? sourceDecorative2;
  final Color? decorative2;
  final Color? onDecorative2;
  final Color? decorative2Container;
  final Color? onDecorative2Container;
  final Color? sourceError;
  final Color? error;
  final Color? onError;
  final Color? errorContainer;
  final Color? onErrorContainer;
  final Color? sourceWarning;
  final Color? warning;
  final Color? onWarning;
  final Color? warningContainer;
  final Color? onWarningContainer;
  final Color? sourceSuccess;
  final Color? success;
  final Color? onSuccess;
  final Color? successContainer;
  final Color? onSuccessContainer;

  @override
  CustomColors copyWith({
    Color? sourceNeutralvariant,
    Color? neutralvariant,
    Color? onNeutralvariant,
    Color? neutralvariantContainer,
    Color? onNeutralvariantContainer,
    Color? sourceDecorative,
    Color? decorative,
    Color? onDecorative,
    Color? decorativeContainer,
    Color? onDecorativeContainer,
    Color? sourceDecorative2,
    Color? decorative2,
    Color? onDecorative2,
    Color? decorative2Container,
    Color? onDecorative2Container,
    Color? sourceError,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? sourceWarning,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? sourceSuccess,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
  }) {
    return CustomColors(
      sourceNeutralvariant: sourceNeutralvariant ?? this.sourceNeutralvariant,
      neutralvariant: neutralvariant ?? this.neutralvariant,
      onNeutralvariant: onNeutralvariant ?? this.onNeutralvariant,
      neutralvariantContainer: neutralvariantContainer ?? this.neutralvariantContainer,
      onNeutralvariantContainer: onNeutralvariantContainer ?? this.onNeutralvariantContainer,
      sourceDecorative: sourceDecorative ?? this.sourceDecorative,
      decorative: decorative ?? this.decorative,
      onDecorative: onDecorative ?? this.onDecorative,
      decorativeContainer: decorativeContainer ?? this.decorativeContainer,
      onDecorativeContainer: onDecorativeContainer ?? this.onDecorativeContainer,
      sourceDecorative2: sourceDecorative2 ?? this.sourceDecorative2,
      decorative2: decorative2 ?? this.decorative2,
      onDecorative2: onDecorative2 ?? this.onDecorative2,
      decorative2Container: decorative2Container ?? this.decorative2Container,
      onDecorative2Container: onDecorative2Container ?? this.onDecorative2Container,
      sourceError: sourceError ?? this.sourceError,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      sourceWarning: sourceWarning ?? this.sourceWarning,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      sourceSuccess: sourceSuccess ?? this.sourceSuccess,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceNeutralvariant: Color.lerp(sourceNeutralvariant, other.sourceNeutralvariant, t),
      neutralvariant: Color.lerp(neutralvariant, other.neutralvariant, t),
      onNeutralvariant: Color.lerp(onNeutralvariant, other.onNeutralvariant, t),
      neutralvariantContainer: Color.lerp(neutralvariantContainer, other.neutralvariantContainer, t),
      onNeutralvariantContainer: Color.lerp(onNeutralvariantContainer, other.onNeutralvariantContainer, t),
      sourceDecorative: Color.lerp(sourceDecorative, other.sourceDecorative, t),
      decorative: Color.lerp(decorative, other.decorative, t),
      onDecorative: Color.lerp(onDecorative, other.onDecorative, t),
      decorativeContainer: Color.lerp(decorativeContainer, other.decorativeContainer, t),
      onDecorativeContainer: Color.lerp(onDecorativeContainer, other.onDecorativeContainer, t),
      sourceDecorative2: Color.lerp(sourceDecorative2, other.sourceDecorative2, t),
      decorative2: Color.lerp(decorative2, other.decorative2, t),
      onDecorative2: Color.lerp(onDecorative2, other.onDecorative2, t),
      decorative2Container: Color.lerp(decorative2Container, other.decorative2Container, t),
      onDecorative2Container: Color.lerp(onDecorative2Container, other.onDecorative2Container, t),
      sourceError: Color.lerp(sourceError, other.sourceError, t),
      error: Color.lerp(error, other.error, t),
      onError: Color.lerp(onError, other.onError, t),
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t),
      onErrorContainer: Color.lerp(onErrorContainer, other.onErrorContainer, t),
      sourceWarning: Color.lerp(sourceWarning, other.sourceWarning, t),
      warning: Color.lerp(warning, other.warning, t),
      onWarning: Color.lerp(onWarning, other.onWarning, t),
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t),
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t),
      sourceSuccess: Color.lerp(sourceSuccess, other.sourceSuccess, t),
      success: Color.lerp(success, other.success, t),
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t),
      successContainer: Color.lerp(successContainer, other.successContainer, t),
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
