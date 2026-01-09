import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Speed dial floating action button for quick actions
/// Provides camera scan, voice input, and manual entry options
class SpeedDialFabWidget extends StatefulWidget {
  const SpeedDialFabWidget({super.key});


  @override
  State<SpeedDialFabWidget> createState() => _SpeedDialFabWidgetState();
}


class _SpeedDialFabWidgetState extends State<SpeedDialFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;


  final List<_SpeedDialAction> _actions = [
    _SpeedDialAction(
      icon: 'camera_alt',
      label: 'Camera Scan',
      color: const Color(0xFF0066CC),
    ),
    _SpeedDialAction(
      icon: 'mic',
      label: 'Voice Input',
      color: const Color(0xFF00A896),
    ),
    _SpeedDialAction(
      icon: 'edit',
      label: 'Manual Entry',
      color: const Color(0xFF3B82F6),
    ),
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );


    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.75,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));


    _scaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _toggleSpeedDial() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isExpanded)
          GestureDetector(
            onTap: _toggleSpeedDial,
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),


        // Speed dial actions
        ..._actions.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          return _buildSpeedDialItem(
            context,
            action,
            index,
            theme,
          );
        }),


        // Main FAB
        Padding(
          padding: EdgeInsets.all(4.w),
          child: FloatingActionButton(
            onPressed: _toggleSpeedDial,
            backgroundColor: theme.colorScheme.primary,
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: CustomIconWidget(
                    iconName: _isExpanded ? 'close' : 'add',
                    size: 28,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  /// Build individual speed dial action item
  Widget _buildSpeedDialItem(
    BuildContext context,
    _SpeedDialAction action,
    int index,
    ThemeData theme,
  ) {
    final offset = (index + 1) * 70.0;


    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset(0, -offset * _scaleAnimation.value),
            child: Padding(
              padding: EdgeInsets.only(right: 4.w, bottom: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Label
                  Material(
                    color: theme.colorScheme.surface,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      child: Text(
                        action.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),


                  // Action button
                  FloatingActionButton(
                    mini: true,
                    onPressed: () => _handleActionTap(context, action),
                    backgroundColor: action.color,
                    child: CustomIconWidget(
                      iconName: action.icon,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  /// Handle speed dial action tap
  void _handleActionTap(BuildContext context, _SpeedDialAction action) {
    _toggleSpeedDial();


    String message;
    switch (action.label) {
      case 'Camera Scan':
        message = 'Opening camera for document scanning...';
        break;
      case 'Voice Input':
        message = 'Voice input activated. Start speaking...';
        break;
      case 'Manual Entry':
        message = 'Opening manual entry form...';
        Navigator.pushNamed(context, '/medical-records-screen');
        return;
      default:
        message = '${action.label} activated';
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: action.color,
      ),
    );
  }
}


/// Speed dial action data model
class _SpeedDialAction {
  final String icon;
  final String label;
  final Color color;


  _SpeedDialAction({
    required this.icon,
    required this.label,
    required this.color,
  });
}
