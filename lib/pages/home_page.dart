import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:the_cat_api/models/cat_model.dart';
import 'package:the_cat_api/pages/search_page.dart';
import 'package:the_cat_api/pages/upload_page.dart';
import 'package:the_cat_api/pages/view_image.dart';
import 'package:the_cat_api/services/grid_view_service.dart';
import 'package:the_cat_api/services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageNumber = 0;
  bool isLoading = true;
  bool isLoadPage = false;
  List<Cat> cats = [];
  ScrollController scrollController = ScrollController();

  // #getting_post_from_api
  void _apiLoadList() async {
    setState(() {
      pageNumber += 1;
    });
    await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber))
        .then((response) => {_showResponse(response)});
  }

  void _showResponse(String? response) {
    setState(() {
      isLoading = false;
      isLoadPage = false;
      if (response != null && cats.isEmpty) {
        cats = Network.parseResponse(response);
      } else if (response != null) {
        cats.addAll(Network.parseResponse(response));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadList();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          isLoadPage = false;
        });
      }
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadPage = true;
          _apiLoadList();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0,
        title: Container(
            width: MediaQuery.of(context).size.width * 0.16,
            height: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(30)),
            child: const Text(
              "All",
              style: TextStyle(fontSize: 17, color: Colors.white),
            )),
        actions: [
          // #search_page
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.id);
              },
              icon: const Icon(
                Icons.search,
                size: 30,
                color: Colors.black,
              )),

          // #uploads_page
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, UploadPage.id);
              },
              icon: const Icon(
                CupertinoIcons.cloud_upload,
                size: 30,
                color: Colors.black,
              )),
        ],
      ),
      body: isLoading && cats.isEmpty
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json",
                  height: 250, width: 250))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // #cat_image
                Expanded(
                    child: RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () async {
                    setState(() {
                      cats.shuffle();
                    });
                  },
                  child: MasonryGridView.count(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemCount: cats.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation, anim) =>
                                          ViewImage(
                                              url: cats[index].url,
                                              idImage: index),
                                      transitionDuration:
                                          const Duration(milliseconds: 400),
                                      transitionsBuilder:
                                          (context, anim1, anim2, child) {
                                        return FadeTransition(
                                            opacity: anim1, child: child);
                                      },
                                      fullscreenDialog: true));
                            },
                            child: Hero(
                                tag: '$index',
                                child: GridWidget(cat: cats[index])));
                      }),
                )),
                isLoadPage
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 50, width: 50),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
    );
  }
}
