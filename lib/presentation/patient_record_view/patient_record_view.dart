import '../../core/app_export.dart';
import 'widgets/patient_header.dart';
import 'widgets/patient_tabs.dart';
import 'widgets/clinical_overview_tab.dart';
import 'widgets/records_tab.dart';
import 'widgets/prescriptions_tab.dart';
import 'widgets/vitals_tab.dart';

class PatientRecordView extends StatefulWidget {
  const PatientRecordView({super.key});

  @override
  State<PatientRecordView> createState() => _PatientRecordViewState();
}

class _PatientRecordViewState extends State<PatientRecordView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Patient Record',
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const PatientHeader(),
          PatientTabs(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ClinicalOverviewTab(),
                RecordsTab(),
                PrescriptionsTab(),
                VitalsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentItem: CustomBottomBarItem.schedule,
        onItemSelected: (item) {
          if (item != CustomBottomBarItem.schedule) {
            Navigator.pushReplacementNamed(context, item.route);
          }
        },
      ),
    );
  }
}
