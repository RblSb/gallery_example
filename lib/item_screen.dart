import 'package:flutter/material.dart';
import 'package:gallery_example/models/image_item.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ImageItemModel item;

  Widget _buildDismissible({
    required BuildContext context,
    required DismissDirection direction,
    required Widget child,
  }) {
    return Dismissible(
      key: Key(item.regularSrc),
      direction: direction,
      onDismissed: (direction) {
        Navigator.of(context).pop();
      },
      resizeDuration: const Duration(milliseconds: 1),
      child: child,
    );
  }

  Widget _buildDismissibles({
    required BuildContext context,
    required Widget child,
  }) {
    return _buildDismissible(
      context: context,
      direction: DismissDirection.horizontal,
      child: _buildDismissible(
        context: context,
        direction: DismissDirection.vertical,
        child: child,
      ),
    );
  }

  Widget imageLoadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent? progress,
  ) {
    if (progress == null) return child;
    final expectedTotalBytes = progress.expectedTotalBytes;
    return Center(
      child: CircularProgressIndicator(
        value: expectedTotalBytes != null
            ? progress.cumulativeBytesLoaded / expectedTotalBytes
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: _buildDismissibles(
        context: context,
        child: Container(
          alignment: Alignment.center,
          child: Image.network(
            item.regularSrc,
            loadingBuilder: imageLoadingBuilder,
          ),
        ),
      ),
    );
  }
}
