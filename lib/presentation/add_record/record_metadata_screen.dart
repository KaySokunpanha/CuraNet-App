import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../services/record_upload_service.dart';
import 'add_record_bottom_sheet.dart';
import 'upload_progress_screen.dart';

/// Record type options for medical records
enum RecordType {
  labReport('Lab Report', Icons.science_outlined),
  prescription('Prescription', Icons.medication_outlined),
  dischargeSummary('Discharge Summary', Icons.summarize_outlined),
  scanXrayMri('Scan / X-Ray / MRI', Icons.medical_information_outlined),
  other('Other', Icons.folder_outlined);

  final String label;
  final IconData icon;
  const RecordType(this.label, this.icon);
}

/// Metadata form screen after file selection
class RecordMetadataScreen extends StatefulWidget {
  final List<PlatformFile>? files;
  final XFile? cameraImage;
  final Uint8List? imageBytes;
  final UploadSource source;

  const RecordMetadataScreen({
    super.key,
    this.files,
    this.cameraImage,
    this.imageBytes,
    required this.source,
  });

  @override
  State<RecordMetadataScreen> createState() => _RecordMetadataScreenState();
}

class _RecordMetadataScreenState extends State<RecordMetadataScreen> {
  RecordType _selectedType = RecordType.other;
  DateTime _recordDate = DateTime.now();
  final _hospitalController = TextEditingController();
  final _doctorController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _suggestRecordType();
  }

  /// Smart suggestion based on filename
  void _suggestRecordType() {
    String? filename;
    
    if (widget.files != null && widget.files!.isNotEmpty) {
      filename = widget.files!.first.name.toLowerCase();
    } else if (widget.cameraImage != null) {
      filename = widget.cameraImage!.name.toLowerCase();
    }
    
    if (filename == null) return;
    
    // Smart detection based on filename keywords
    if (filename.contains('lab') || 
        filename.contains('test') || 
        filename.contains('report') ||
        filename.contains('cbc') ||
        filename.contains('blood')) {
      setState(() => _selectedType = RecordType.labReport);
    } else if (filename.contains('prescription') || 
               filename.contains('rx') ||
               filename.contains('medicine')) {
      setState(() => _selectedType = RecordType.prescription);
    } else if (filename.contains('discharge') || 
               filename.contains('summary')) {
      setState(() => _selectedType = RecordType.dischargeSummary);
    } else if (filename.contains('xray') || 
               filename.contains('x-ray') ||
               filename.contains('mri') ||
               filename.contains('scan') ||
               filename.contains('ct')) {
      setState(() => _selectedType = RecordType.scanXrayMri);
    }
  }

  @override
  void dispose() {
    _hospitalController.dispose();
    _doctorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _fileCount {
    if (widget.files != null) return widget.files!.length;
    if (widget.cameraImage != null) return 1;
    return 0;
  }

  String get _fileNames {
    if (widget.files != null && widget.files!.isNotEmpty) {
      if (widget.files!.length == 1) {
        return widget.files!.first.name;
      }
      return '${widget.files!.length} files selected';
    }
    if (widget.cameraImage != null) {
      return 'Camera photo';
    }
    return 'No file';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Record Details',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File preview card
            _buildFilePreviewCard(),
            const SizedBox(height: 24),

            // Record Type
            _buildSectionLabel('Record Type *'),
            const SizedBox(height: 12),
            _buildRecordTypeDropdown(),
            const SizedBox(height: 20),

            // Record Date
            _buildSectionLabel('Record Date *'),
            const SizedBox(height: 12),
            _buildDatePicker(),
            const SizedBox(height: 20),

            // Hospital/Lab Name
            _buildSectionLabel('Hospital / Lab Name'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _hospitalController,
              hint: 'e.g., Apollo Hospitals',
              icon: Icons.local_hospital_outlined,
            ),
            const SizedBox(height: 20),

            // Doctor Name
            _buildSectionLabel('Doctor Name'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _doctorController,
              hint: 'e.g., Dr. Sharma',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),

            // Notes
            _buildSectionLabel('Notes'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              hint: 'Any additional notes...',
              icon: Icons.notes_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Save Button
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Preview thumbnail
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      widget.imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    _getFileIcon(),
                    color: const Color(0xFF2196F3),
                    size: 28,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _fileNames,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.source == UploadSource.camera
                      ? 'From Camera'
                      : 'From Device',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green[400], size: 24),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    if (widget.files != null && widget.files!.isNotEmpty) {
      final ext = widget.files!.first.extension?.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
        return Icons.image_outlined;
      } else if (ext == 'pdf') {
        return Icons.picture_as_pdf_outlined;
      } else if (['doc', 'docx'].contains(ext)) {
        return Icons.description_outlined;
      } else if (['xls', 'xlsx'].contains(ext)) {
        return Icons.table_chart_outlined;
      }
    }
    return Icons.insert_drive_file_outlined;
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildRecordTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<RecordType>(
        value: _selectedType,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: RecordType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Row(
              children: [
                Icon(type.icon, size: 20, color: const Color(0xFF2196F3)),
                const SizedBox(width: 12),
                Text(type.label),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedType = value);
          }
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, 
                color: Color(0xFF2196F3), size: 20),
            const SizedBox(width: 12),
            Text(
              DateFormat('dd MMM yyyy').format(_recordDate),
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            Icon(Icons.edit_outlined, color: Colors.grey[400], size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _recordDate = picked);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: const Color(0xFF2196F3), size: 20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveRecord,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Save Record',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _saveRecord() async {
    setState(() => _isLoading = true);

    // Prepare metadata
    final metadata = RecordMetadata(
      recordType: _selectedType.name,
      recordDate: _recordDate,
      hospitalName: _hospitalController.text.trim().isEmpty 
          ? null 
          : _hospitalController.text.trim(),
      doctorName: _doctorController.text.trim().isEmpty 
          ? null 
          : _doctorController.text.trim(),
      notes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
    );

    // Navigate to upload progress screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UploadProgressScreen(
          files: widget.files,
          cameraImage: widget.cameraImage,
          imageBytes: widget.imageBytes,
          metadata: metadata,
        ),
      ),
    );
  }
}
