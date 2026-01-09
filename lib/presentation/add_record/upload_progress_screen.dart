import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/record_upload_service.dart';

/// Upload progress screen with status updates and retry capability
class UploadProgressScreen extends StatefulWidget {
  final List<PlatformFile>? files;
  final XFile? cameraImage;
  final Uint8List? imageBytes;
  final RecordMetadata metadata;

  const UploadProgressScreen({
    super.key,
    this.files,
    this.cameraImage,
    this.imageBytes,
    required this.metadata,
  });

  @override
  State<UploadProgressScreen> createState() => _UploadProgressScreenState();
}

class _UploadProgressScreenState extends State<UploadProgressScreen>
    with SingleTickerProviderStateMixin {
  UploadStatus _status = UploadStatus.uploading;
  String? _errorMessage;
  int _currentFileIndex = 0;
  int _totalFiles = 0;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _totalFiles = widget.files?.length ?? 1;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _startUpload();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startUpload() async {
    setState(() {
      _status = UploadStatus.uploading;
      _errorMessage = null;
    });

    try {
      final uploadService = RecordUploadService();
      
      if (widget.files != null && widget.files!.isNotEmpty) {
        // Upload files from device
        for (int i = 0; i < widget.files!.length; i++) {
          setState(() => _currentFileIndex = i + 1);
          
          final file = widget.files![i];
          await uploadService.uploadFile(
            filename: file.name,
            fileBytes: file.bytes!,
            mimeType: _getMimeType(file.extension ?? ''),
            metadata: widget.metadata,
          );
        }
      } else if (widget.imageBytes != null) {
        // Upload camera image
        await uploadService.uploadFile(
          filename: 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg',
          fileBytes: widget.imageBytes!,
          mimeType: 'image/jpeg',
          metadata: widget.metadata,
        );
      }

      setState(() => _status = UploadStatus.success);
      _animationController.stop();
      
      // Auto-navigate back after success
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      setState(() {
        _status = UploadStatus.failed;
        _errorMessage = e.toString();
      });
      _animationController.stop();
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'md':
        return 'text/markdown';
      default:
        return 'application/octet-stream';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_status == UploadStatus.uploading) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel Upload?'),
              content: const Text('Your files are still uploading. Are you sure you want to cancel?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Continue Upload'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIcon(),
                  const SizedBox(height: 32),
                  _buildStatusText(),
                  const SizedBox(height: 16),
                  _buildProgressInfo(),
                  if (_status == UploadStatus.failed) ...[
                    const SizedBox(height: 32),
                    _buildRetryButton(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    const iconSize = 100.0;
    
    switch (_status) {
      case UploadStatus.uploading:
        return ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                  ),
                ),
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF2196F3),
                  size: 40,
                ),
              ],
            ),
          ),
        );
      
      case UploadStatus.success:
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 56,
          ),
        );
      
      case UploadStatus.failed:
        return Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 56,
          ),
        );
    }
  }

  Widget _buildStatusText() {
    switch (_status) {
      case UploadStatus.uploading:
        return const Column(
          children: [
            Text(
              'Uploading...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please keep the app open',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        );
      
      case UploadStatus.success:
        return const Column(
          children: [
            Text(
              'Upload Complete!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your record has been saved securely',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        );
      
      case UploadStatus.failed:
        return Column(
          children: [
            const Text(
              'Upload Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Something went wrong',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  Widget _buildProgressInfo() {
    if (_status != UploadStatus.uploading) return const SizedBox.shrink();
    
    if (_totalFiles > 1) {
      return Text(
        'File $_currentFileIndex of $_totalFiles',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRetryButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _startUpload,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry Upload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

enum UploadStatus { uploading, success, failed }
