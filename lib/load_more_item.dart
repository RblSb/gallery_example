import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/app.dart';

class LoadMoreItem extends StatelessWidget {
  const LoadMoreItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
