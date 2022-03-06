import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:the_cat_api/models/cat_model.dart';
import 'package:the_cat_api/services/grid_view_service.dart';
import 'package:the_cat_api/services/http_service.dart';

class SearchPage extends StatefulWidget {
  static const String id = "search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;
  bool isLoadPage = false;
  List<Cat> cats = [];
  int pageNumber = 0;
  final ScrollController _scrollController = ScrollController();

  // #getting_post_from_api
  void _apiLoadList() async {
    setState(() {
      isLoading = true;
      pageNumber += 1;
    });
    print("Page number: $pageNumber");
    await Network.GET(Network.API_LIST,
            Network.paramsSearch(_controller.text, pageNumber))
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          margin:
              const EdgeInsets.only(top: 40, right: 10, left: 10, bottom: 10),
          // #search_text_field
          child: TextField(
            onSubmitted: (text) {
              setState(() {
                cats.clear();
                pageNumber = 0;
              });
              _apiLoadList();
            },
            style: const TextStyle(fontSize: 18),
            controller: _controller,
            decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 10),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)),
                filled: true,
                fillColor: Colors.grey.shade300,
                hintText: "Search by Breed",
                hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 18),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 30,
                )),
          ),
        ),
      ),
      body: isLoading && cats.isEmpty
          ? Center(
              child: Lottie.asset("assets/lottie/loading.json",
                  height: 250, width: 250))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MasonryGridView.count(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: cats.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 11,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) {
                        return GridWidget(cat: cats[index]);
                      }),
                ),
                isLoadPage
                    ? Center(
                        child: Lottie.asset("assets/lottie/loading.json",
                            height: 50, width: 50))
                    : const SizedBox.shrink(),
              ],
            ),
    );
  }
}
