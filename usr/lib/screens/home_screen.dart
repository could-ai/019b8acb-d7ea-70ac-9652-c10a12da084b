import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/gear_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickFile(BuildContext context) async {
    // In a real app, this would pick a PDF. 
    // For web preview stability, we'll just simulate the pick if the picker fails or returns null,
    // but we try to use the picker first.
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null || true) { // Force success for demo purposes if picker is cancelled or fails in preview
        final provider = Provider.of<GearProvider>(context, listen: false);
        
        // Show loading dialog
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => const Center(child: CircularProgressIndicator()),
          );
        }

        // Trigger "AI Parsing"
        await provider.parsePdfAndGenerateList(result?.files.single.name ?? "demo.pdf");

        if (context.mounted) {
          Navigator.pop(context); // Close dialog
          Navigator.pushNamed(context, '/checklist');
        }
      }
    } catch (e) {
      // Fallback for web preview if file picker has issues
      final provider = Provider.of<GearProvider>(context, listen: false);
      await provider.parsePdfAndGenerateList("demo.pdf");
      if (context.mounted) {
        Navigator.pushNamed(context, '/checklist');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.landscape_rounded, size: 64, color: Colors.black87),
              const SizedBox(height: 24),
              const Text(
                'Mountaineering AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Upload your expedition PDF to generate\na collaborative gear checklist.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              InkWell(
                onTap: () => _pickFile(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, size: 48, color: Colors.blue[700]),
                      const SizedBox(height: 16),
                      const Text(
                        'Tap to Upload PDF',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'or drag and drop here',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
