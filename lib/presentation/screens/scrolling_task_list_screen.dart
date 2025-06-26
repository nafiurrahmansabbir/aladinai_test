import 'package:aladinai_test/presentation/utls/app_colors.dart';
import 'package:flutter/material.dart';

import '../data/list_data.dart';

class ScrollingTaskListScreen extends StatefulWidget {
  const ScrollingTaskListScreen({super.key});

  @override
  State<ScrollingTaskListScreen> createState() => _ScrollingTaskListScreenState();
}

class _ScrollingTaskListScreenState extends State<ScrollingTaskListScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> allItems = ListData.allItems;

  List<String> items = [];
  final int batchSize = 20;
  int currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading) {
        _loadMoreData();
      }
    });
  }

  Future<void> _loadMoreData() async {
    if (currentIndex >= allItems.length) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    int nextIndex = currentIndex + batchSize;
    if (nextIndex > allItems.length) nextIndex = allItems.length;

    setState(() {
      items.addAll(allItems.getRange(currentIndex, nextIndex));
      currentIndex = nextIndex;
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits Scrolling',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.themeColor,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) return _buildProgressIndicator();
          return Card(
            color: AppColors.cardColor,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(title: Text(items[index])),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return _isLoading
        ? const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    )
        : const SizedBox.shrink();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
