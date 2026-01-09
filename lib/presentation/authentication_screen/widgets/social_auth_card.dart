import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Social authentication card widget
/// Displays Google or Apple sign-in options with official branding
class SocialAuthCard extends StatelessWidget {
  final String provider; // 'Google' or 'Apple'
  final VoidCallback onTap;
  final bool isLoading;


  const SocialAuthCard({
    super.key,
    required this.provider,
    required this.onTap,
    required this.isLoading,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGoogle = provider == 'Google';


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
                  color: isGoogle
                      ? const Color(0xFFEA4335).withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isGoogle ? 'g_translate' : 'apple',
                    color: isGoogle ? const Color(0xFFEA4335) : Colors.black,
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
                      'Sign in with $provider',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isGoogle
                          ? 'Use your Google account'
                          : 'Use your Apple ID',
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
