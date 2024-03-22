import 'package:flutter/material.dart';

class LazyLoadingScreen extends StatefulWidget {
  const LazyLoadingScreen({super.key});

  @override
  State<LazyLoadingScreen> createState() => _LazyLoadingScreenState();
}

class _LazyLoadingScreenState extends State<LazyLoadingScreen> {
  final ScrollController _controller = ScrollController();

  bool _isLoading = false;
  final List<String> _dummy = List.generate(20, (index) => 'Item ${index+1}');

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_controller.offset >=
        _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      _fetchData();
    }
  }

  Future _fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    int lastIndex = _dummy.length;

    setState(() {
      _dummy.addAll(
          List.generate(15, (index) => "New Item ${lastIndex+index}")
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy loading screen"),
      ),
      body: ListView.builder(
        controller: _controller,
        itemCount: _isLoading ? _dummy.length + 1 : _dummy.length,
        itemBuilder: (context, index) {
          if (_dummy.length == index) {
            return const Center(
                child: CircularProgressIndicator()
            );
          }
          return ListTile(
              title: Text(
                  _dummy[index]
              )
          );
        },
      ),
    );
  }
}
