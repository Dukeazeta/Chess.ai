import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/floating_window_provider.dart';
import '../services/chess_analysis_service.dart';

class FloatingChessWindow extends StatefulWidget {
  const FloatingChessWindow({super.key});

  @override
  State<FloatingChessWindow> createState() => _FloatingChessWindowState();
}

class _FloatingChessWindowState extends State<FloatingChessWindow> {
  bool _isExpanded = false;
  String _currentAnalysis = "Tap to analyze position";
  bool _isAnalyzing = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _analyzePosition() async {
    setState(() {
      _isAnalyzing = true;
      _currentAnalysis = "Analyzing...";
    });
    
    try {
      // This would be replaced with actual screen capture and analysis
      final analysis = await ChessAnalysisService.analyzeCurrentPosition();
      setState(() {
        _currentAnalysis = analysis;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _currentAnalysis = "Analysis failed: ${e.toString()}";
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<FloatingWindowProvider>(context);
    
    return Positioned(
      left: provider.position.dx,
      top: provider.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          final newPosition = Offset(
            (provider.position.dx + details.delta.dx).clamp(0, size.width - (_isExpanded ? 250 : 50)),
            (provider.position.dy + details.delta.dy).clamp(0, size.height - (_isExpanded ? 200 : 50)),
          );
          provider.updatePosition(newPosition);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _isExpanded ? 250 : 50,
          height: _isExpanded ? 200 : 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: _isExpanded 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _toggleExpand,
                          iconSize: 18,
                        ),
                        const Text(
                          'Chess Assistant',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: _analyzePosition,
                          iconSize: 18,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isAnalyzing
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Text(
                                  _currentAnalysis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _ActionButton(
                            icon: Icons.lightbulb_outline,
                            label: 'Hint',
                            onPressed: () {
                              setState(() {
                                _currentAnalysis = "Best move: e4 to e5\nThis opens up your bishop and controls the center.";
                              });
                            },
                          ),
                          _ActionButton(
                            icon: Icons.warning_amber_outlined,
                            label: 'Blunder',
                            onPressed: () {
                              setState(() {
                                _currentAnalysis = "Watch out! Your queen is under attack.";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: _toggleExpand,
                  child: Center(
                    child: Icon(
                      Icons.sports_esports,
                      size: 25,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
