import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatefulWidget {
  final int index;
  final List<String> urls;
  final int count;
  bool isPath;
  bool isNetwork;

  PhotoViewScreen({
    Key? key,
    required this.index,
    required this.urls,
    required this.count,
    this.isPath = false,
    this.isNetwork = false,
  }) : super(key: key);

  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  bool showNavs = true;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      maxTransformValue: .8,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppbar(),
          body: _buildBody(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 44),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        opacity: showNavs ? 1 : 0,
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.abc),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return PhotoViewGallery.builder(
      pageController: PageController(initialPage: widget.index),
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions.customChild(
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 12.0,
          child: GestureDetector(
            onTap: () => setState(() {
              showNavs = !showNavs;
            }),
            child: widget.isPath
                ? widget.isNetwork
                    ? ExtendedImage.network(
                        widget.urls[index],
                        clearMemoryCacheWhenDispose: true,
                        fit: BoxFit.cover,
                        enableMemoryCache: false,
                        enableLoadState: false,
                        compressionRatio: 0.8,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        height: 190,
                        width: 190,
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case LoadState.completed:
                              return state.completedWidget;
                            default:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                          }
                        },
                      )
                    : Image.file(File(widget.urls[index]))
                : Image(
                    image: AssetImage(
                      'assets/images/${widget.urls[index]}',
                    ),
                  ),
          ),
          initialScale: PhotoViewComputedScale.contained * 1,
        );
      },
      itemCount: widget.count,
      loadingBuilder: (context, event) => const SizedBox.expand(
        child: Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
