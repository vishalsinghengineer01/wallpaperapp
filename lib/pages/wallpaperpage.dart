import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:wallpaperapp/pages/models.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  Color myHexColor = const Color(0xFF92D6DB);
  List data = [];

  TextEditingController searchImage = TextEditingController();
  List<CatergrieList> categoryList = [
    CatergrieList(
        catergrieTitle: 'Architecture',
        catergrietImage: 'assets/images/architecture.jpg'),
    CatergrieList(
        catergrieTitle: 'Movie',
        catergrietImage: 'assets/images/movie.jpg'),
    CatergrieList(
        catergrieTitle: 'Travel',
        catergrietImage: 'assets/images/travel.jpg'),
    CatergrieList(
        catergrieTitle: 'Animal',
        catergrietImage: 'assets/images/animal.jpg'),
    CatergrieList(
        catergrieTitle: 'Food',
        catergrietImage: 'assets/images/food.jpg'),
    CatergrieList(
        catergrieTitle: 'Sport',
        catergrietImage: 'assets/images/sport.jpg'),
    CatergrieList(
        catergrieTitle: 'Nature',
        catergrietImage: 'assets/images/nature.jpg'),
  ];



  @override
  void initState() {
    super.initState();
    getphoto(categoryList[0]);
  }

  getphoto(search) async {
    setState(() {
      data = [];
    });

    try {
      final url = Uri.parse(
          'https://api.unsplash.com/search/photos/?client_id=AlICnt3ytvnZhLzy6ZVSulE_zV5vY6rKIXuC8Cz2ld8&query=$search&per_page=30');

      var response = await http.get(url);

      var result = jsonDecode(response.body);

      data = result['results'];
      print(data);

      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          topRow(),
          searchbar(),
          const Center(
              child: Text(
            'Categories can have a look at',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          const SizedBox(
            height: 20,
          ),
          horizontalbuilder(),
          const SizedBox(
            height: 20,
          ),
          verticalBuilder(),
        ],
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
              double ht = index % 2 == 0 ? 200 : 100;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: InstaImageViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data[index]['urls']['regular'],
                      height: ht,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            })
        : const SizedBox(
            height: 500,
            child: Center(
              child: SpinKitCircle(color: Colors.grey),
            ));
  }

  Widget horizontalbuilder() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              getphoto(categoryList[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(categoryList[index].catergrietImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  categoryList[index].catergrieTitle,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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

  Widget topRow() {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/logo.jpeg',
              fit: BoxFit.cover,
              height: 40,
              width: 40,
            )),
        const SizedBox(
          width: 50,
        ),
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: 'Wallpaper ',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: myHexColor,
                fontFamily: 'cv'),
          ),
          const TextSpan(
            text: 'App',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontFamily: 'cv'),
          ),
        ])),
      ],
    );
  }
}
