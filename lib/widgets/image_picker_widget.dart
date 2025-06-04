import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  final String apiKey = "Mn8MoLnXCopxvzVipO8DnQ0H-ryaaWYnKChoeI1gWws";
  Color myHexColor = const Color(0xFF92D6DB);
  List data = [];

  TextEditingController searchImage = TextEditingController();

  Future<void> getphoto(String search) async {
    setState(() {
      data = [];
    });

    try {
      final url = Uri.parse(
          'https://api.unsplash.com/search/photos/?client_id=$apiKey&query=$search&per_page=30');
      var response = await http.get(url);
      var result = jsonDecode(response.body);
      data = result['results'];
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getphoto('Cats');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 600,
        height: 700,
        child: Column(
          children: [
            // Custom "AppBar"
            Container(
              decoration: BoxDecoration(
                color: myHexColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // Placeholder for symmetry
                  Text(
                    'Search for images',
                    style: TextStyle(
                      fontFamily: 'Aboreto',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            searchbar(),
            Expanded(
              child: SingleChildScrollView(
                child: verticalBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verticalBuilder() {
    return data.isNotEmpty
        ? MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(data[index]['urls']['regular']);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data[index]['urls']['regular'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            })
        : const Center(child: Text('No images found'));
  }

  Widget searchbar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchImage,
                decoration: const InputDecoration(
                  hintText: 'Search images (nature, animals)...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    getphoto(value);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: myHexColor,
            iconSize: 30,
            onPressed: () {
              if (searchImage.text.isNotEmpty) {
                getphoto(searchImage.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
