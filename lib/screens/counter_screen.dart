import 'package:flutter/material.dart';
import 'package:internship_task_manager/services/storage_service.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    setState(() {
      _isLoading = true;
    });
    
    final savedCounter = await StorageService.loadCounter();
    
    if (mounted) {
      setState(() {
        _counter = savedCounter;
        _isLoading = false;
      });
    }
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await StorageService.saveCounter(_counter);
  }

  Future<void> _decrementCounter() async {
    setState(() {
      _counter--;
    });
    await StorageService.saveCounter(_counter);
  }

  Future<void> _resetCounter() async {
    setState(() {
      _counter = 0;
    });
    await StorageService.saveCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Counter Value',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.4),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$_counter',
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          icon: Icons.remove_rounded,
                          onPressed: _decrementCounter,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 20),
                        _buildActionButton(
                          icon: Icons.refresh_rounded,
                          onPressed: _resetCounter,
                          color: Colors.orange,
                          isSquare: true,
                        ),
                        const SizedBox(width: 20),
                        _buildActionButton(
                          icon: Icons.add_rounded,
                          onPressed: _incrementCounter,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.green[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Auto-saved',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[700],
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
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    bool isSquare = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isSquare ? BorderRadius.circular(16) : null,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: isSquare
              ? BorderRadius.circular(16)
              : BorderRadius.circular(50),
          child: Container(
            width: isSquare ? 60 : 64,
            height: 64,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

