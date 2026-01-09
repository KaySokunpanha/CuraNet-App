import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item configuration for bottom navigation bar
enum CustomBottomBarItem {
  healthId,
  records,
  schedule, // New Schedule Tab
  profile;

  String get label {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return 'Health ID';
      case CustomBottomBarItem.records:
        return 'Records';
      case CustomBottomBarItem.schedule:
        return 'Schedule';
      case CustomBottomBarItem.profile:
        return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return Icons.credit_card_rounded;
      case CustomBottomBarItem.records:
        return Icons.folder_outlined;
      case CustomBottomBarItem.schedule:
        return Icons.calendar_month_outlined;
      case CustomBottomBarItem.profile:
        return Icons.person_outline_rounded;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return Icons.credit_card;
      case CustomBottomBarItem.records:
        return Icons.folder;
      case CustomBottomBarItem.schedule:
        return Icons.calendar_month;
      case CustomBottomBarItem.profile:
        return Icons.person;
    }
  }

  String get route {
    switch (this) {
      case CustomBottomBarItem.healthId:
        return '/health-dashboard';
      case CustomBottomBarItem.records:
        return '/medical-records-screen';
      case CustomBottomBarItem.schedule:
        return '/schedule-screen';
      case CustomBottomBarItem.profile:
        return '/profile-screen';
    }
  }
}

/// Custom bottom navigation bar for healthcare application
/// Implements bottom-heavy interaction design with 48dp touch targets
/// Optimized for one-handed operation during clinical visits
class CustomBottomBar extends StatelessWidget {
  /// Current selected navigation item
  final CustomBottomBarItem currentItem;

  /// Callback when navigation item is tapped
  final ValueChanged<CustomBottomBarItem>? onItemSelected;

  /// Whether to show emergency FAB
  final bool showEmergencyFab;

  /// Callback for emergency FAB tap
  final VoidCallback? onEmergencyTap;

  /// Whether the bottom bar should be elevated
  final bool elevated;

  const CustomBottomBar({
    super.key,
    required this.currentItem,
    this.onItemSelected,
    this.showEmergencyFab = true,
    this.onEmergencyTap,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              // Navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: CustomBottomBarItem.values.map((item) {
                  return _NavigationItem(
                    item: item,
                    isSelected: currentItem == item,
                    onTap: () {
                      if (onItemSelected != null) {
                        onItemSelected!(item);
                      } else {
                        Navigator.pushNamed(context, item.route);
                      }
                    },
                    colorScheme: colorScheme,
                    isDark: isDark,
                  );
                }).toList(),
              ),

              // Emergency FAB overlay
              if (showEmergencyFab)
                Positioned(
                  right: 16,
                  bottom: 72,
                  child: _EmergencyFab(
                    onTap: onEmergencyTap,
                    colorScheme: colorScheme,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation item widget
class _NavigationItem extends StatelessWidget {
  final CustomBottomBarItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final bool isDark;

  const _NavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isDark
        ? const Color(0xFF3B8FE8)
        : const Color(0xFF0066CC);
    final unselectedColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: primaryColor.withValues(alpha: 0.1),
        highlightColor: primaryColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with 48dp touch target
              SizedBox(
                height: 28,
                width: 28,
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  size: 24,
                  color: isSelected ? primaryColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected ? primaryColor : unselectedColor,
                  letterSpacing: 0.4,
                  height: 1.33,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Emergency SOS floating action button
/// Positioned in bottom-right for thumb accessibility
/// 56dp touch target for stress situations and gloved hands
class _EmergencyFab extends StatelessWidget {
  final VoidCallback? onTap;
  final ColorScheme colorScheme;

  const _EmergencyFab({this.onTap, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emergencyColor = isDark
        ? const Color(0xFFEF4444)
        : const Color(0xFFDC2626);

    return Material(
      color: emergencyColor,
      elevation: 4,
      shadowColor: (isDark ? Colors.white : Colors.black).withValues(
        alpha: 0.08,
      ),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap:
            onTap ??
            () {
              // Default emergency action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Emergency SOS activated',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: emergencyColor,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: const Icon(
            Icons.emergency_rounded,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Provider role variant of bottom navigation bar
/// Separate navigation context for clinical workflows
class CustomProviderBottomBar extends StatelessWidget {
  /// Current selected navigation item for provider
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int>? onItemSelected;

  /// Whether the bottom bar should be elevated
  final bool elevated;

  const CustomProviderBottomBar({
    super.key,
    required this.currentIndex,
    this.onItemSelected,
    this.elevated = true,
  });

  static const List<_ProviderNavItem> _items = [
    _ProviderNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: '/health-dashboard',
    ),
    _ProviderNavItem(
      label: 'Patients',
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      route: '/medical-records-screen',
    ),
    _ProviderNavItem(
      label: 'Schedule',
      icon: Icons.event_note_outlined,
      activeIcon: Icons.event_note,
      route: '/patient-record-view',
    ),
    _ProviderNavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person,
      route: '/authentication-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.black).withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = currentIndex == index;
              final primaryColor = isDark
                  ? const Color(0xFF3B8FE8)
                  : const Color(0xFF0066CC);
              final unselectedColor = isDark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF6B7280);

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (onItemSelected != null) {
                      onItemSelected!(index);
                    } else {
                      Navigator.pushNamed(context, item.route);
                    }
                  },
                  splashColor: primaryColor.withValues(alpha: 0.1),
                  highlightColor: primaryColor.withValues(alpha: 0.05),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 24,
                            color: isSelected ? primaryColor : unselectedColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: isSelected ? primaryColor : unselectedColor,
                            letterSpacing: 0.4,
                            height: 1.33,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Provider navigation item data class
class _ProviderNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const _ProviderNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}
