import 'package:flutter/material.dart';
import 'package:hymns/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'arr.dart';

final BASEURL_IMAGE =
    "https://raw.githubusercontent.com/f2janyway/hymn_files/master/";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '새찬송가 1962',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '새찬송가 1962'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(initialPage: 0);
  final _currentPageIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentPageIndexNotifier.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawerHolder(
        currentPageIndexNotifier: _currentPageIndexNotifier,
        pageController: _pageController,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: PageView.builder(
              itemCount: titlePairList.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                final _resource =
                    "imgs/hymn/" + pageFileNameOrderedList[index] + ".jpeg";
                // Uri.file(resource)
                final resource = Uri.encodeFull(_resource);
                debugPrint(resource);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageScreen(source: resource),
                      ),
                    );
                  },
                  child: PhotoView(
                    imageProvider: AssetImage(resource),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.contained * 2,
                    initialScale: PhotoViewComputedScale.contained,
                  ),
                );
              },
              onPageChanged: (index) {
                _currentPageIndexNotifier.value = index;
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: PageViewButtons(
              currentPageIndexNotifier: _currentPageIndexNotifier,
              pageController: _pageController,
              lastIndex: pageFileNameOrderedList.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}
