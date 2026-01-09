import 'package:flutter/material.dart';

// Export core packages
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

// Export utilities
// export 'utils/image_constant.dart';
// export 'utils/size_utils.dart';
// export 'utils/validation_functions.dart';

// Export theme
export '../theme/app_theme.dart';

// Export widgets
export '../widgets/custom_app_bar.dart';
export '../widgets/custom_bottom_bar.dart';
export '../widgets/custom_icon_widget.dart';
export '../widgets/custom_image_widget.dart';
export '../widgets/custom_error_widget.dart';

// Export routes
export '../routes/app_routes.dart';

// Global keys
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
