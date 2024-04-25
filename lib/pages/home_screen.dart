import 'package:flutter/material.dart';
import 'package:plant_recognition/consts/color_const.dart';
import 'package:plant_recognition/pages/camera_screen.dart';
import 'package:plant_recognition/pages/widgets/plant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> options = ['Цэцэг', 'Мод', 'Навч', 'Эмийн ургамал'];
  String selected = 'Цэцэг';

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
              Icon(
                Icons.camera,
                color: Colors.white,
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
        title: const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Row(
            children: [
              Icon(
                Icons.eco,
                color: defaultGreen,
              ),
              SizedBox(width: 8),
              Text('Home'),
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
            TextFormField(
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
                  return const SizedBox(
                    width: 200,
                    child: PlantCard(),
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
