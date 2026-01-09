import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = _iconMap[iconName];
    
    if (iconData == null) {
      return Icon(Icons.error, color: color, size: size);
    }

    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }

  static final Map<String, IconData> _iconMap = {
    'medical_services': Icons.medical_services,
    'verified_user': Icons.verified_user,
    'security': Icons.security,
    'arrow_back': Icons.arrow_back,
    'check': Icons.check,
    'close': Icons.close,
    'add': Icons.add,
    'edit': Icons.edit,
    'delete': Icons.delete,
    'search': Icons.search,
    'home': Icons.home,
    'person': Icons.person,
    'settings': Icons.settings,
    'info': Icons.info,
    'warning': Icons.warning,
    'error': Icons.error,
    'chevron_right': Icons.chevron_right,
    'chevron_left': Icons.chevron_left,
    'expand_more': Icons.expand_more,
    'expand_less': Icons.expand_less,
    'more_vert': Icons.more_vert,
    'more_horiz': Icons.more_horiz,
    'menu': Icons.menu,
    'filter_list': Icons.filter_list,
    'sort': Icons.sort,
    'calendar_today': Icons.calendar_today,
    'access_time': Icons.access_time,
    'location_on': Icons.location_on,
    'phone': Icons.phone,
    'email': Icons.email,
    'lock': Icons.lock,
    'visibility': Icons.visibility,
    'visibility_off': Icons.visibility_off,
    'fingerprint': Icons.fingerprint,
    'g_mobiledata': Icons.g_mobiledata,
    'apple': Icons.apple,
    'facebook': Icons.facebook,
    'notifications': Icons.notifications,
    'notifications_none': Icons.notifications_none,
    'monitor_heart': Icons.monitor_heart,
    'medication': Icons.medication,
    'description': Icons.description,
    'folder': Icons.folder,
    'folder_open': Icons.folder_open,
    'credit_card': Icons.credit_card,
    'receipt': Icons.receipt,
    'local_hospital': Icons.local_hospital,
    'thermostat': Icons.thermostat,
    'monitor_weight': Icons.monitor_weight,
    'height': Icons.height,
    'bloodtype': Icons.bloodtype,
    'vaccines': Icons.vaccines,
    'healing': Icons.healing,
    'sick': Icons.sick,
    'coronavirus': Icons.coronavirus,
    'pregnant_woman': Icons.pregnant_woman,
    'child_care': Icons.child_care,
    'elderly': Icons.elderly,
    'wheelchair_pickup': Icons.wheelchair_pickup,
    'emergency': Icons.emergency,
    'call': Icons.call,
    'chat': Icons.chat,
    'video_call': Icons.video_call,
    'share': Icons.share,
    'download': Icons.download,
    'upload': Icons.upload,
    'print': Icons.print,
    'save': Icons.save,
    'logout': Icons.logout,
    'login': Icons.login,
  };
}
