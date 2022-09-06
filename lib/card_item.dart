import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_screen.dart';
import 'models/app.dart';
import 'models/image_item.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ImageItemModel item;

  Widget buildLoadMoreCard(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: () {
            final app = Provider.of<AppModel>(context, listen: false);
            app.loadMoreImages();
          },
          child: const SizedBox.expand(
            child: Align(
              alignment: Alignment.center,
              child: FittedBox(
                child: Text(
                  'Load\nMore',
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      shadows: [Shadow(blurRadius: 5)],
    );
    return Center(
      child: Card(
        margin: const EdgeInsets.all(1),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(item: item),
              ),
            );
          },
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.network(
                  item.thumbSrc,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    item.description,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: textStyle,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 18,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          item.userName,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: textStyle,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
