import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cri_pat_5/model/dummy/dummy_assets.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget(this.imageURL, {this.heroTag, this.id, Key? key})
      : super(key: key);

  final String? imageURL;
  final String? heroTag;
  final String? id;

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

const localImgReplacer = "@@@local@@@";

class _ImageWidgetState extends State<ImageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static final _cacheManager = CacheManager(
    Config(
      'images',
      stalePeriod: const Duration(days: 7),
    ),
  );

  Widget _image(BuildContext context, String? _imageURL) {
    print(_imageURL);
    String localUrl = DummyAssets.randMunichImage;
    print(localUrl);
    print((_imageURL ?? "").isNotEmpty);
    if ((_imageURL ?? "").startsWith(localImgReplacer)) {
      localUrl = (_imageURL ?? "").replaceAll(localImgReplacer, "");
      _imageURL = null;
    }

    if ((_imageURL ?? "").isNotEmpty) {
      print("entering correct if");
      return Image.asset(
        _imageURL!, // The path to the local image
        fit: BoxFit.cover, // To ensure the image fits the available space
        errorBuilder: (context, error, stackTrace) {
          print(error);
          return _defaultImage(
              localUrl); // Fallback to the default image if there's an issue
        },
      );
    }

    return _defaultImage(localUrl);
  }

  Widget _defaultImage(String localUrl) {
    return Image.asset(
      localUrl,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final image = _image(context, widget.imageURL);

    // This prevents having multiple "unknown-unknown" hero tags, which crash the app
    if (widget.heroTag == null || widget.id == null) {
      return image;
    }

    return Hero(
      tag: (widget.heroTag ?? "unknown") + "-" + (widget.id ?? "unknown"),
      child: image,
    );
  }
}
