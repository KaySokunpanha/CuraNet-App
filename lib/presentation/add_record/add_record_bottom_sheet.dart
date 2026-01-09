import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'record_metadata_screen.dart';

/// Bottom sheet for selecting upload source (Device/Camera)
class AddRecordBottomSheet extends StatelessWidget {
  const AddRecordBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AddRecordBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          const Text(
            'Add Medical Record',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to add your record',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Upload from Device option
          _UploadOptionTile(
            icon: Icons.upload_file_rounded,
            iconColor: const Color(0xFF2196F3),
            title: 'Upload from Device',
            subtitle: 'Select PDF, images, or documents',
            onTap: () => _pickFiles(context),
          ),
          
          const SizedBox(height: 12),
          
          // Take Photo option
          _UploadOptionTile(
            icon: Icons.camera_alt_rounded,
            iconColor: const Color(0xFF4CAF50),
            title: 'Take Photo',
            subtitle: 'Capture using camera',
            onTap: () => _takePhoto(context),
          ),
          
          const SizedBox(height: 24),
          
          // Supported formats info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Supported: Images, PDF, Word, Excel (Max 20MB)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Future<void> _pickFiles(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg', 'jpeg', 'png', 'gif', 'webp',  // Images
          'pdf',                                  // PDF
          'doc', 'docx',                          // Word
          'xls', 'xlsx',                          // Excel
          'txt', 'csv', 'md',                     // Text
        ],
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        Navigator.pop(context); // Close bottom sheet
        
        // Validate file sizes (20MB limit)
        final validFiles = <PlatformFile>[];
        final oversizedFiles = <String>[];
        
        for (final file in result.files) {
          if (file.size > 20 * 1024 * 1024) {
            oversizedFiles.add(file.name);
          } else {
            validFiles.add(file);
          }
        }
        
        if (oversizedFiles.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File(s) too large (>20MB): ${oversizedFiles.join(", ")}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        
        if (validFiles.isNotEmpty) {
          // Navigate to metadata screen with files
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecordMetadataScreen(
                files: validFiles,
                source: UploadSource.device,
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting files: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compress to save space
        maxWidth: 2000,
        maxHeight: 2000,
      );

      if (photo != null) {
        Navigator.pop(context); // Close bottom sheet
        
        // Convert XFile to PlatformFile-like structure
        final bytes = await photo.readAsBytes();
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordMetadataScreen(
              cameraImage: photo,
              imageBytes: bytes,
              source: UploadSource.camera,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Reusable upload option tile widget
class _UploadOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

enum UploadSource { device, camera }
