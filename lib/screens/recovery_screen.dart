import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/ai_recovery_engine.dart';
import '../models/super_file.dart';
import '../providers/recovery_provider.dart';
import '../widgets/recovery_card.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({Key? key}) : super(key: key);

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AIRecoveryEngine _engine;
  List<SuperFile> files = [];
  bool isScanning = false;
  double scanProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _engine = AIRecoveryEngine();
    _scanController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  Future<void> startUltimateScan() async {
    setState(() {
      isScanning = true;
      scanProgress = 0.0;
    });
    _scanController.repeat();

    try {
      files = await _engine.ultraDeepScan('/storage/emulated/0');
      context.read<RecoveryProvider>().setRecoveredFiles(files);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Found ${files.length} recoverable files!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Scan failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      _scanController.stop();
      setState(() => isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'DeepScan Pro',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.purple.shade500,
                              Colors.pink.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.0,
                              (_scanController.value * 0.5 + 0.5),
                              1.0
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (isScanning)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              strokeWidth: 6,
                              value: scanProgress,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '🔍 Ultra Deep Scanning...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${(scanProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade600,
                          Colors.purple.shade500,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isScanning ? null : startUltimateScan,
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 18,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isScanning ? Icons.hourglass_top : Icons.search,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isScanning ? 'Scanning...' : '🚀 START RECOVERY SCAN',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!isScanning && files.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_search,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap the button above to start scanning',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (files.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Found ${files.length} Files',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(
                        'Success: ${(files.map((f) => f.recoveryScore).reduce((a, b) => a + b) / files.length).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green.shade600,
                    ),
                  ],
                ),
              ),
            ),
          if (files.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => RecoveryCard(file: files[index]),
                  childCount: files.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _engine.dispose();
    super.dispose();
  }
}
