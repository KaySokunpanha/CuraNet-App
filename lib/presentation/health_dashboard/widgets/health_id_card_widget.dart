import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Health ID Card with 3D tilt effect and QR code
/// Displays patient's medical identification information
class HealthIdCardWidget extends StatelessWidget {
  const HealthIdCardWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;


    return Tilt(
      borderRadius: BorderRadius.circular(16),
      tiltConfig: const TiltConfig(
        angle: 10,
        enableGestureSensors: true,
      ),
      lightConfig: LightConfig(
        color: theme.colorScheme.primary.withValues(alpha: 0.3),
        minIntensity: 0.1,
        maxIntensity: 0.5,
      ),
      shadowConfig: ShadowConfig(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
        minIntensity: 0.05,
        maxIntensity: 0.15,
      ),
      child: GestureDetector(
        onTap: () => _showFullScreenCard(context),
        onLongPress: () => _showShareOptions(context),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 25.h,
            maxHeight: 30.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardPatternPainter(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),


              // Card content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with logo and card type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'medical_services',
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'CuraNet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'HEALTH ID',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: 2.h),


                    // Patient info and QR code
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile photo and info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Profile photo
                                Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: CustomImageWidget(
                                      imagePath:
                                          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                                      width: 15.w,
                                      height: 15.w,
                                      fit: BoxFit.cover,
                                      semanticLabel:
                                          'Profile photo of Sarah Johnson, a woman with shoulder-length brown hair wearing a light blue top',
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.5.h),


                                // Name
                                Text(
                                  'Sarah Johnson',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),


                                // Health ID number
                                Text(
                                  'ID: CN-2024-789456',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontFamily: 'monospace',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),


                                // Blood type and DOB
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 2.w,
                                        vertical: 0.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'O+',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'DOB: 03/15/1985',
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),


                          // QR Code
                          Container(
                            width: 20.w,
                            height: 20.w,
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomImageWidget(
                              imagePath:
                                  'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=CN-2024-789456',
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.contain,
                              semanticLabel:
                                  'QR code containing health ID CN-2024-789456 for quick scanning',
                            ),
                          ),
                        ],
                      ),
                    ),


                    // Footer with verified badge
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'verified',
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Verified Health ID',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Show full-screen card view
  void _showFullScreenCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HealthIdCardWidget(),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Show share options
  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'share',
                size: 24,
              ),
              title: const Text('Share Health ID'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID shared successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: const CustomIconWidget(
                iconName: 'download',
                size: 24,
              ),
              title: const Text('Download as Image'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Health ID downloaded'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/// Custom painter for card background pattern
class _CardPatternPainter extends CustomPainter {
  final Color color;


  _CardPatternPainter({required this.color});


  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;


    // Draw grid pattern
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }


    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
