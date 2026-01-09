import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';


import '../../../core/app_export.dart';


/// Vitals tab widget displaying patient vital signs and charts
class VitalsTabWidget extends StatelessWidget {
  final Map<String, dynamic> patientData;


  const VitalsTabWidget({
    super.key,
    required this.patientData,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vitals = patientData['vitals'] as Map<String, dynamic>;


    return ListView(
      padding: EdgeInsets.all(4.w),
      children: [
        // Current Vitals Grid
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 2.h,
          crossAxisSpacing: 4.w,
          childAspectRatio: 1.5,
          children: [
            _buildVitalCard(
              theme,
              'Blood Pressure',
              vitals['bloodPressure'] as String,
              'mmHg',
              'favorite',
              Colors.red,
            ),
            _buildVitalCard(
              theme,
              'Heart Rate',
              vitals['heartRate'] as String,
              'bpm',
              'monitor_heart',
              Colors.blue,
            ),
            _buildVitalCard(
              theme,
              'Temperature',
              vitals['temperature'] as String,
              '°F',
              'thermostat',
              Colors.orange,
            ),
            _buildVitalCard(
              theme,
              'Oxygen Level',
              vitals['oxygenLevel'] as String,
              '%',
              'air',
              Colors.teal,
            ),
          ],
        ),
        SizedBox(height: 3.h),


        // Blood Pressure Chart
        _buildChartCard(
          theme,
          'Blood Pressure History',
          _buildBloodPressureChart(theme),
        ),
        SizedBox(height: 2.h),


        // Heart Rate Chart
        _buildChartCard(
          theme,
          'Heart Rate History',
          _buildHeartRateChart(theme),
        ),
      ],
    );
  }


  Widget _buildVitalCard(
    ThemeData theme,
    String title,
    String value,
    String unit,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 24,
              ),
              Text(
                unit,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildChartCard(ThemeData theme, String title, Widget chart) {
    return Container(
      height: 35.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(child: chart),
        ],
      ),
    );
  }


  Widget _buildBloodPressureChart(ThemeData theme) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          // Systolic
          LineChartBarData(
            spots: [
              FlSpot(0, 120),
              FlSpot(1, 118),
              FlSpot(2, 122),
              FlSpot(3, 119),
              FlSpot(4, 121),
              FlSpot(5, 120),
            ],
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          // Diastolic
          LineChartBarData(
            spots: [
              FlSpot(0, 80),
              FlSpot(1, 78),
              FlSpot(2, 82),
              FlSpot(3, 79),
              FlSpot(4, 81),
              FlSpot(5, 80),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }


  Widget _buildHeartRateChart(ThemeData theme) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 72),
              FlSpot(1, 75),
              FlSpot(2, 70),
              FlSpot(3, 74),
              FlSpot(4, 72),
              FlSpot(5, 73),
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}
