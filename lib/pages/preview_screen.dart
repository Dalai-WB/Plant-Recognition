import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:extended_image/extended_image.dart';
import 'package:plant_recognition/consts/color_const.dart';
import 'package:plant_recognition/helper/database_helper.dart';
import 'package:plant_recognition/pages/home_screen.dart';
import 'package:plant_recognition/pages/widgets/image_preview.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plant_recognition/pages/widgets/photo_view_screen.dart';

class PreviewScreen extends StatefulWidget {
  final String plantTitle;
  final String imageUrl;
  bool isPath;
  PreviewScreen({
    super.key,
    required this.plantTitle,
    required this.imageUrl,
    this.isPath = false,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late Map<String, dynamic> data;
  bool isLoading = true;
  List<String> otherImages = [];
  bool isOffline = true;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then(
      (List<ConnectivityResult> result) {
        _updateConnectionStatus(result);
      },
    );
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    if (!_connectionStatus.contains(ConnectivityResult.none)) {
      isOffline = false;
    } else {
      isOffline = true;
    }
    getData();
  }

  getData() {
    databaseHelper.getData(widget.plantTitle).then((value) {
      if (!isOffline) {
        otherImages.clear();
        for (var i = 0; i < 3; i++) {
          otherImages.add(
              'https://mytrip-media.s3.ap-northeast-2.amazonaws.com/plant-recognition/${value.first['plantId']}/index${i + 1}.jpg');
        }
      }
      setState(() {
        isLoading = false;
        data = value.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => const HomeScreen()),
      //         (route) => false),
      //   ),
      //   title: const Text(
      //     'Үр дүн',
      //   ),
      // ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: widget.isPath
                        ? Image.file(
                            File(widget.imageUrl),
                          )
                        : Image(
                            image: AssetImage(
                              'assets/images/${widget.imageUrl}',
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 300),
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 24,
                      right: 24,
                      bottom: 16,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.plantTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff292c2d),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            '${data['description']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: const Image(
                                image:
                                    AssetImage('assets/images/common-name.png'),
                                height: 28,
                              ),
                              title: const Text('Нийтлэг нэр'),
                              textColor: textColor,
                              subtitle: Text(
                                '${data['commonName']}',
                              ),
                              tileColor: Colors.white,
                              subtitleTextStyle:
                                  const TextStyle(color: textColor),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: const Image(
                                image: AssetImage(
                                    'assets/images/plant-family.png'),
                                height: 28,
                              ),
                              title: const Text('Аймаг'),
                              textColor: textColor,
                              subtitle: Text(
                                '${data['family']}',
                              ),
                              tileColor: Colors.white,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              leading: const Image(
                                image:
                                    AssetImage('assets/images/plant-genus.png'),
                                height: 28,
                              ),
                              title: const Text('Төрөл зүйл'),
                              textColor: textColor,
                              subtitle: Text(
                                '${data['genus']}',
                              ),
                              tileColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          !isOffline
                              ? const Text(
                                  'Ургамлын нэмэлт зургууд',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff292c2d),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 8),
                          !isOffline
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      spacing: 8,
                                      children: otherImages.map((e) {
                                        print(e);
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PhotoViewScreen(
                                                index: 0,
                                                urls: otherImages,
                                                count: 3,
                                                isNetwork: true,
                                                isPath: true,
                                              ),
                                            ),
                                          ),
                                          child: ExtendedImage.network(
                                            e,
                                            clearMemoryCacheWhenDispose: true,
                                            fit: BoxFit.cover,
                                            enableMemoryCache: false,
                                            enableLoadState: false,
                                            compressionRatio: 0.1,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            height: 190,
                                            width: 190,
                                            loadStateChanged:
                                                (ExtendedImageState state) {
                                              switch (state
                                                  .extendedImageLoadState) {
                                                case LoadState.loading:
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                case LoadState.completed:
                                                  return state.completedWidget;
                                                default:
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                              }
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
