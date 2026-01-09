import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App bar variant types for different contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and actions
  standard,

  /// Search-focused app bar with search field
  search,

  /// Profile/settings app bar with avatar
  profile,

  /// Medical record detail app bar with share action
  recordDetail,

  /// Emergency mode app bar with critical styling
  emergency;
}

/// Custom app bar for healthcare application
/// Implements Medical Precision Minimalism with clean interfaces
/// Optimized for clinical environments and mobile contexts
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Title text displayed in the app bar
  final String? title;

  /// Subtitle text displayed below title (optional)
  final String? subtitle;

  /// Leading widget (typically back button or menu)
  final Widget? leading;

  /// Action widgets displayed on the right
  final List<Widget>? actions;

  /// Whether to show back button automatically
  final bool automaticallyImplyLeading;

  /// App bar variant type
  final CustomAppBarVariant variant;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (overrides theme)
  final Color? backgroundColor;

  /// Elevation of the app bar
  final double? elevation;

  /// Search query callback for search variant
  final ValueChanged<String>? onSearchChanged;

  /// Search submit callback for search variant
  final ValueChanged<String>? onSearchSubmitted;

  /// Initial search query for search variant
  final String? initialSearchQuery;

  /// Avatar URL for profile variant
  final String? avatarUrl;

  /// Avatar tap callback for profile variant
  final VoidCallback? onAvatarTap;

  /// Share callback for record detail variant
  final VoidCallback? onShare;

  /// Emergency callback for emergency variant
  final VoidCallback? onEmergencyAction;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.variant = CustomAppBarVariant.standard,
    this.centerTitle = false,
    this.backgroundColor,
    this.elevation,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.initialSearchQuery,
    this.avatarUrl,
    this.onAvatarTap,
    this.onShare,
    this.onEmergencyAction,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, isDark);
      case CustomAppBarVariant.profile:
        return _buildProfileAppBar(context, theme, isDark);
      case CustomAppBarVariant.recordDetail:
        return _buildRecordDetailAppBar(context, theme, isDark);
      case CustomAppBarVariant.emergency:
        return _buildEmergencyAppBar(context, theme, isDark);
      case CustomAppBarVariant.standard:
        return _buildStandardAppBar(context, theme, isDark);
    }
  }

  /// Standard app bar with title and actions
  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);

    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: centerTitle
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: 0.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            )
          : Text(
              title ?? '',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 0.15,
              ),
            ),
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  /// Search-focused app bar with search field
  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);

    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: false,
      title: Container(
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: TextField(
          controller: TextEditingController(text: initialSearchQuery),
          onChanged: onSearchChanged,
          onSubmitted: onSearchSubmitted,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
          ),
          decoration: InputDecoration(
            hintText: 'Search medical records...',
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              size: 20,
            ),
            suffixIcon:
                initialSearchQuery != null && initialSearchQuery!.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                          size: 20,
                        ),
                        onPressed: () {
                          if (onSearchChanged != null) {
                            onSearchChanged!('');
                          }
                        },
                      )
                    : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list_rounded,
            color: textColor,
            size: 24,
          ),
          onPressed: () {
            // Filter action
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  /// Profile app bar with avatar
  Widget _buildProfileAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);

    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(
        title ?? 'Profile',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.15,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor:
                  isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC),
              backgroundImage:
                  avatarUrl != null ? NetworkImage(avatarUrl!) : null,
              child: avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
        ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  /// Record detail app bar with share action
  Widget _buildRecordDetailAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final bgColor =
        backgroundColor ?? (isDark ? const Color(0xFF111827) : Colors.white);
    final textColor =
        isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151);
    final primaryColor =
        isDark ? const Color(0xFF3B8FE8) : const Color(0xFF0066CC);

    return AppBar(
      backgroundColor: bgColor,
      elevation: elevation ?? 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(
        title ?? 'Medical Record',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.15,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share_rounded,
            color: primaryColor,
            size: 24,
          ),
          onPressed: onShare ??
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Share medical record',
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
          tooltip: 'Share record',
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert_rounded,
            color: textColor,
            size: 24,
          ),
          onPressed: () {
            // More options
          },
        ),
        ...?actions,
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
    );
  }

  /// Emergency mode app bar with critical styling
  Widget _buildEmergencyAppBar(
      BuildContext context, ThemeData theme, bool isDark) {
    final emergencyColor =
        isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);

    return AppBar(
      backgroundColor: emergencyColor,
      elevation: elevation ?? 4,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emergency_rounded,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            title ?? 'EMERGENCY MODE',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onEmergencyAction ??
              () {
                Navigator.of(context).pop();
              },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            'EXIT',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.25,
            ),
          ),
        ),
        ...?actions,
      ],
    );
  }
}
