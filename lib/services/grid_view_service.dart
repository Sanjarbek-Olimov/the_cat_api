import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_cat_api/models/cat_model.dart';
import 'package:the_cat_api/models/uploads_model.dart';
import 'http_service.dart';

class GridWidget extends StatefulWidget {
  Cat? cat;
  Uploads? upload;
  ValueChanged<List<Uploads>>? update;
  List<Uploads>? list;
  GridWidget({Key? key, this.cat, this.upload, this.update, this.list}) : super(key: key);

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  void deleteSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        builder: (context) {
          return Container(
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.08,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                widget.list!.remove(widget.upload);
                widget.update!(widget.list!);
                Navigator.pop(context);
                await Network.DELETE(Network.API_DELETE + widget.upload!.id,
                    Network.paramsEmpty());
              },
              horizontalTitleGap: 0,
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text(
                "Delete image",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.cat != null ? widget.cat!.url : widget.upload!.url;
    int width = widget.cat != null ? widget.cat!.width : widget.upload!.width;
    int height =
        widget.cat != null ? widget.cat!.height : widget.upload!.height;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => AspectRatio(
                aspectRatio: width / height,
                child: Container(color: Colors.grey)),
            errorWidget: (context, url, error) => AspectRatio(
                aspectRatio: widget.cat!.width / widget.cat!.height,
                child: Container(color: Colors.grey)),
          ),
        ),
        widget.cat == null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: deleteSheet, child: const Icon(Icons.more_horiz))
                ],
              )
            : const SizedBox.shrink()
      ],
    );
  }
}
