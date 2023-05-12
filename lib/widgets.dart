import 'package:flutter/material.dart';
import 'package:hymns/util.dart';
import 'package:photo_view/photo_view.dart';
import 'arr.dart';

class PageViewButtons extends StatelessWidget {
  const PageViewButtons({
    Key? key,
    required this.currentPageIndexNotifier,
    required this.pageController,
    required this.lastIndex,
  }) : super(key: key);
  final ValueNotifier<int> currentPageIndexNotifier;
  final PageController pageController;

  final int lastIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FloatingActionButton(
          onPressed: () {
            pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          heroTag: "123",
          child: const Icon(Icons.arrow_left),
        ),
        
        FloatingActionButton(
          onPressed: () {
            pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          },
          heroTag: "321",
          child: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String source;

  const FullScreenImageScreen({required this.source});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: PhotoView(
              imageProvider: AssetImage(source),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.contained * 2,
              initialScale: PhotoViewComputedScale.contained,
            ),
      ),
    );
  }
}

class MyDrawerHolder extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPageIndexNotifier;

  const MyDrawerHolder({
    Key? key,
    required this.currentPageIndexNotifier,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPageIndexNotifier,
      builder: (context, currentPageIndex, _) {
        return MyDrawer(
          pageController: pageController,
          index: currentPageIndex,
        );
      },
    );
  }
}

class MyDrawer extends StatefulWidget {
  final PageController pageController;
  final int index;

  const MyDrawer({Key? key, required this.pageController, required this.index})
      : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  final _scrollController = ScrollController();
  int _realPageIndex = 0;
  @override
  void initState() {
    super.initState();
    _search('');

    debugPrint("widget.index:${widget.index}");
    // if (widget.index == 0) return;

    final fileName = pageFileNameOrderedList[widget.index];
    final title = titlePairList.entries
        .firstWhere((element) => element.value == fileName)
        .key;
    _realPageIndex =
        indexPairList.entries.firstWhere((el) => el.value == title).key;
    if (_realPageIndex >= 0) {
      // _scrollController.jumpTo(_realPageIndex as double);
      // _scrollController.animateTo(
      //   _realPageIndex * 26.0, // The height of each ListTile in the ListView
      //   duration: const Duration(milliseconds: 100),
      //   curve: Curves.easeInOut,
      // );
    }
    // debugPrint("_realPageIndex:$_realPageIndex");
    // final title = titlePairList.keys.elementAt(_realPageIndex);
    // debugPrint("title:$title");
    // if (_filteredItems.isNotEmpty) {
    //   final index = _filteredItems.indexOf(title);
    //   debugPrint("last index:$index");
    // } else {
    // }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _search(String query) {
    setState(() {
      _filteredItems = titleNumberList
          .where((title) =>
              title.toLowerCase().contains(query.trim().toLowerCase()))
          .toList();
      if (query.isEmpty) {
        _filteredItems = List.from(titleNumberList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final title = _filteredItems[index];
                final songNum = title.split(" ")[0];
                final realPageIndex = getCurrentPage(int.parse(songNum));
                // debugPrint("in list view: real page index: $realPageIndex");
                return ListTile(
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    widget.pageController.jumpToPage(realPageIndex);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
