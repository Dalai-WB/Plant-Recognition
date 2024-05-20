import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plant_recognition/consts/color_const.dart';
import 'package:plant_recognition/helper/database_helper.dart';
import 'package:plant_recognition/pages/camera_screen.dart';
import 'package:plant_recognition/pages/preview_screen.dart';
import 'package:plant_recognition/pages/widgets/plant_card.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper db = DatabaseHelper();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  var suggestData = [];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  List<String> titles = [];
  final List<String> options = ['Цэцэг', 'Мод', 'Жимс', 'Эмийн ургамал'];
  final List<String> englishOptions = ['plant', 'tree', 'fruit', 'medical'];
  final flowerTitles = [
    'Anemone coronaria L.',
    "Pelargonium graveolens L'H\u00e9r.",
    "Pelargonium zonale (L.) L'H\u00e9r."
  ];
  final treeTitles = [
    'Acacia dealbata Link',
    'Liriodendron tulipifera L.',
    'Punica granatum L.'
  ];
  final fruitTitles = [
    'Punica granatum L.',
    'Fragaria vesca L.',
    'Cucurbita maxima Duchesne'
  ];
  final medicalTitles = [
    'Calendula officinalis L.',
    "Pelargonium graveolens L'H\u00e9r.",
    'Hypericum perforatum L.'
  ];
  String selected = 'Цэцэг';
  bool isOffline = false;
  String? searchString = '';

  Future<void> updateSuggestions(String query) async {
    var data = await db.getDatas(query);
    setState(() {
      suggestData = data;
    });
  }

  @override
  void initState() {
    super.initState();

    titles = flowerTitles;

    Connectivity().checkConnectivity().then(
      (List<ConnectivityResult> result) {
        _updateConnectionStatus(result);
      },
    );

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        _updateConnectionStatus(result);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus.contains(ConnectivityResult.none)) {
        isOffline = true;
      } else {
        isOffline = false;
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CameraScreen(),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 32,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: defaultGreen,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'image-icon',
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Tаниулах',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Row(
            children: [
              const Icon(
                Icons.eco,
                color: defaultGreen,
              ),
              const SizedBox(width: 8),
              Text('Home${isOffline ? ' - Offline' : ''}'),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ургамлын сан',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            SearchAnchor(
              viewBackgroundColor: Colors.white,
              builder: (
                BuildContext context,
                SearchController controller,
              ) {
                return TextFormField(
                  onTap: () => controller.openView(),
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Ургамлын нэрээ оруулна уу',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: inputBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onSaved: (String? value) {},
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                );
              },
              suggestionsBuilder: (
                BuildContext context,
                SearchController controller,
              ) {
                updateSuggestions(controller.value.text);
                return suggestData.map<ListTile>((element) {
                  return ListTile(
                    title: Text(element['scientificName'] ?? ''),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PreviewScreen(
                            plantTitle: element['scientificName'],
                            imageUrl: 'template.jpg',
                          ),
                        ),
                      );
                    },
                  );
                }).toList();
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var isSelected = (options[index] == selected);
                  return _buildChip(options[index], isSelected);
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: options.length,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3 + 10,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 200,
                    child: PlantCard(
                      imageUrl:
                          '${englishOptions[options.indexOf(selected)]}-${index + 1}.jpg',
                      title: titles[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String labelText, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = labelText;
          switch (options.indexWhere((element) => element == selected)) {
            case 0:
              titles = flowerTitles;
              break;
            case 1:
              titles = treeTitles;
              break;
            case 2:
              titles = fruitTitles;
              break;
            case 3:
              titles = medicalTitles;
              break;
          }
        });
      },
      child: Chip(
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(
          labelText,
          style: TextStyle(
            color: isActive ? Colors.white : appGrey,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isActive ? defaultGreen : inputBG,
            width: 1.0,
          ),
        ),
        backgroundColor: isActive ? defaultGreen : Colors.white,
        elevation: 0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}
