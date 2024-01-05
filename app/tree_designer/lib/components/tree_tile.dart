import 'dart:math';

import 'package:flutter/material.dart';

class TreeTile extends StatelessWidget {
  final String treeId;
  final VoidCallback deleteCallback;
  final Function(String) loadCallback;
  final Color color;

  const TreeTile({Key? key, required this.treeId, required this.deleteCallback, required this.color, required this.loadCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                loadCallback(treeId);
              },
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(size * 0.1),
                ),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Icon(
                      Icons.park,
                      color: Colors.white,
                      size: size * 0.375,
                    ),
                    const Spacer(),
                    Container(
                      width: size,
                      height: size * 0.25,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size * 0.1),
                          bottomRight: Radius.circular(size * 0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          treeId,
                          style:
                          TextStyle(color: Colors.white, fontSize: size * 0.15, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 0,
              child : InkWell(
                  onTap: deleteCallback,
                  borderRadius : BorderRadius.circular(size * 0.1),
                  child : Icon(Icons.delete,color : Colors.white,size : size * 0.25)
              ),
            ),
          ],
        );
      },
    );
  }
}
