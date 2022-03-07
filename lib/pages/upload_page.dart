import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:the_cat_api/models/uploads_model.dart';
import 'package:the_cat_api/pages/view_image.dart';
import 'package:the_cat_api/services/grid_view_service.dart';
import 'package:the_cat_api/services/http_service.dart';

class UploadPage extends StatefulWidget {
  static const String id = "upload_page";

  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  ImagePicker picker = ImagePicker();
  var image;
  bool isUploading = false;
  bool isLoadingUploads = true;
  List<Uploads> uploads = [];
  ScrollController scrollController = ScrollController();

  void _update(List<Uploads> update) {
    setState(() => uploads = update);
  }

  Future getMyImage(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    });
  }

  void _apiGetUploads() async {
    await Network.GET(Network.API_GET_UPLOADS, Network.paramsPage(0))
        .then((value) {
      setState(() {
        uploads = uploadsFromJson(value!);
        isLoadingUploads = false;
        image = null;
        isUploading = false;
      });
    });
  }

  void _apiUploadImage() async {
    setState(() {
      isUploading = true;
    });
    await Network.MULTIPART(
            Network.API_UPLOAD, image.path, Network.paramsUpload())
        .then((response) => {_showResponse(response)});
  }

  void _showResponse(String? response) {
    setState(() {
      if (response != null) {
        _apiGetUploads();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetUploads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Uploads",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          image == null
              ? const SizedBox.shrink()
              : MaterialButton(
                  minWidth: 75,
                  onPressed: () {
                    setState(() {
                      image = null;
                      isUploading = false;
                    });
                  },
                  child: const Text("Delete"),
                  padding: EdgeInsets.zero,
                )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isUploading
                ? const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 5,
            ),

            // #image_selector
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: image == null
                  ? const Center(child: Text("Select an image to upload"))
                  : Image.file(
                      image,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            image == null
                ? Column(
                    children: [
                      MaterialButton(
                        minWidth: 200,
                        height: 40,
                        onPressed: () {
                          getMyImage(ImageSource.gallery);
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      MaterialButton(
                        minWidth: 200,
                        height: 40,
                        onPressed: () {
                          getMyImage(ImageSource.camera);
                        },
                        child: const Text(
                          "Camera",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Colors.blueGrey,
                        textColor: Colors.white,
                      ),
                    ],
                  )
                : MaterialButton(
                    minWidth: 200,
                    height: 40,
                    onPressed: _apiUploadImage,
                    child: const Text(
                      "Upload",
                      style: TextStyle(fontSize: 20),
                    ),
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                  ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),

            // #uploads_image
            Expanded(
              child: uploads.isNotEmpty
                  ? MasonryGridView.count(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemCount: uploads.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, animation, anim) =>
                                        ViewImage(
                                            url: uploads[index].url,
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
                            tag: "$index",
                            child: GridWidget(
                              upload: uploads[index],
                              update: _update,
                              list: uploads,
                            ),
                          ),
                        );
                      })
                  : Center(
                      child: isLoadingUploads
                          ? Lottie.asset("assets/lottie/loading.json",
                              height: 200, width: 200)
                          : const Text(
                              "No uploads",
                              style: TextStyle(fontSize: 18),
                            )),
            )
          ],
        ),
      ),
    );
  }
}
