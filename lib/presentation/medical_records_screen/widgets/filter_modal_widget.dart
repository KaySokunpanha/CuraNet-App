import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Filter modal for medical records
class FilterModalWidget extends StatefulWidget {
  final Set<String> activeFilters;
  final DateTimeRange? dateRange;
  final bool showVerifiedOnly;
  final Function(Set<String>, DateTimeRange?, bool) onApplyFilters;


  const FilterModalWidget({
    super.key,
    required this.activeFilters,
    required this.dateRange,
    required this.showVerifiedOnly,
    required this.onApplyFilters,
  });


  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}


class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Set<String> _selectedCategories;
  late DateTimeRange? _selectedDateRange;
  late bool _verifiedOnly;


  final List<String> _categories = [
    'Lab Results',
    'Prescriptions',
    'Imaging',
    'Reports',
  ];


  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.activeFilters);
    _selectedDateRange = widget.dateRange;
    _verifiedOnly = widget.showVerifiedOnly;
  }


  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
            ),
          ),
          child: child!,
        );
      },
    );


    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }


  void _clearAllFilters() {
    setState(() {
      _selectedCategories.clear();
      _selectedDateRange = null;
      _verifiedOnly = false;
    });
  }


  void _applyFilters() {
    widget.onApplyFilters(
      _selectedCategories,
      _selectedDateRange,
      _verifiedOnly,
    );
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),


            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Text(
                    'Filters',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Divider(
              color: theme.colorScheme.outline,
              height: 1,
            ),


            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category filters
                    Text(
                      'Categories',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ..._categories.map((category) {
                      final isSelected = _selectedCategories.contains(category);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedCategories.add(category);
                            } else {
                              _selectedCategories.remove(category);
                            }
                          });
                        },
                        title: Text(
                          category,
                          style: theme.textTheme.bodyMedium,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      );
                    }),


                    SizedBox(height: 2.h),


                    // Date range
                    Text(
                      'Date Range',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: _selectDateRange,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'date_range',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                _selectedDateRange == null
                                    ? 'Select date range'
                                    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: _selectedDateRange == null
                                      ? theme.colorScheme.onSurfaceVariant
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            if (_selectedDateRange != null)
                              IconButton(
                                icon: CustomIconWidget(
                                  iconName: 'clear',
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() => _selectedDateRange = null);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: 2.h),


                    // Verification status
                    Text(
                      'Verification Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    SwitchListTile(
                      value: _verifiedOnly,
                      onChanged: (value) {
                        setState(() => _verifiedOnly = value);
                      },
                      title: Text(
                        'Show verified records only',
                        style: theme.textTheme.bodyMedium,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),


                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),


            // Apply button
            Padding(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
