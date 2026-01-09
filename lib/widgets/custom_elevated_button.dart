import 'package:sizer/sizer.dart';
import '../core/app_export.dart';


class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    this.margin,
    this.onPressed,
    this.buttonStyle,
    this.alignment,
    this.buttonTextStyle,
    this.isDisabled,
    this.height,
    this.width,
    required this.text,
  });


  final BoxDecoration? decoration;


  final Widget? leftIcon;


  final Widget? rightIcon;


  final EdgeInsets? margin;


  final VoidCallback? onPressed;


  final ButtonStyle? buttonStyle;


  final Alignment? alignment;


  final TextStyle? buttonTextStyle;


  final bool? isDisabled;


  final double? height;


  final double? width;


  final String text;


  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildElevatedButtonWidget(context),
          )
        : _buildElevatedButtonWidget(context);
  }


  Widget _buildElevatedButtonWidget(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height ?? 48.sp,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Text(
              text,
              style: buttonTextStyle ?? theme.textTheme.bodyLarge,
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
