import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Phone/OTP authentication card widget
/// Displays phone number login option with country code selector
class PhoneAuthCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;


  const PhoneAuthCard({
    super.key,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(3.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 12.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: (isDark
                          ? const Color(0xFF00C9B7)
                          : const Color(0xFF00A896))
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'phone_android',
                    color: isDark
                        ? const Color(0xFF00C9B7)
                        : const Color(0xFF00A896),
                    size: 8.w,
                  ),
                ),
              ),


              SizedBox(width: 4.w),


              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Phone / OTP',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Login with phone number verification',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),


              SizedBox(width: 2.w),


              // Arrow icon
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: theme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
