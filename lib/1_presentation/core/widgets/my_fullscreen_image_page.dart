import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyFullscreenImagePage extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;
  final bool isNetworkImage;

  const MyFullscreenImagePage({
    super.key,
    required this.imagePaths,
    required this.initialIndex,
    required this.isNetworkImage,
  });

  @override
  State<MyFullscreenImagePage> createState() => _MyFullscreenImagePageState();
}

class _MyFullscreenImagePageState extends State<MyFullscreenImagePage> with SingleTickerProviderStateMixin {
  late TransformationController transformationController;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  bool isPageViewScrollable = true;
  bool isDoubleTappedOnImage = false;

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        transformationController.value = animation!.value;
      });
  }

  @override
  void dispose() {
    super.dispose();
    transformationController.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isDoubleTappedOnImage == true) {
      isPageViewScrollable = !transformationController.value.isIdentity();
    }
    print(transformationController.value[0]);
    print('isPageViewScrollable? = $isPageViewScrollable');
    print('transformationController.value.isIdentity()? = ${transformationController.value.isIdentity()}');
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: widget.initialIndex),
        physics: !isPageViewScrollable ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
        onPageChanged: (value) {
          setState(() {
            transformationController = TransformationController();
            isPageViewScrollable = true;
            isDoubleTappedOnImage = false;
          });
        },
        itemCount: widget.imagePaths.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: widget.imagePaths[index],
            child: Container(
              color: Colors.black,
              child: Center(
                child: Dismissible(
                  key: const Key('fullscreen'),
                  direction: isPageViewScrollable ? DismissDirection.down : DismissDirection.none,
                  onDismissed: (_) {
                    Navigator.pop(context);
                  },
                  child: buildImage(widget.imagePaths[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildImage(String image) => GestureDetector(
        onDoubleTapDown: (details) {
          tapDownDetails = details;
          setState(() {});
        },
        onDoubleTap: () {
          final position = tapDownDetails!.localPosition;

          const double scale = 3;
          final x = -position.dx * (scale - 1);
          final y = -position.dy * (scale - 1);
          final zoomed = Matrix4.identity()
            ..translate(x, y)
            ..scale(scale);

          final value = transformationController.value.isIdentity() ? zoomed : Matrix4.identity();
          //transformationController.value = value;

          animation = Matrix4Tween(
            begin: transformationController.value,
            end: value,
          ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));

          animationController.forward(from: 0);
          
          setState(() {
            isDoubleTappedOnImage = true;
          });
        },
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          transformationController: transformationController,
          //panEnabled: false,
          //scaleEnabled: false,
          maxScale: 10,
          onInteractionUpdate: (details) {
            print('onInteractionUpdate = ${details.scale}');
            print(transformationController.value[0].toString());
            setState(() {
              isDoubleTappedOnImage = false;
              if (transformationController.value[0] == 1.0) {
                isPageViewScrollable = true;
              } else {
                isPageViewScrollable = false;
              }
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: !widget.isNetworkImage
                ? Image.file(
                    File(image),
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
          ),
        ),
      );
}
