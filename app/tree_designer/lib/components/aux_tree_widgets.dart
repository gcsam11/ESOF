import 'package:flutter/material.dart';
import 'package:tree_designer/components/person_window.dart';

import '../data_classes/person.dart';

class AddParentsButton extends StatelessWidget {
  final Person person;
  final VoidCallback callBack;

  const AddParentsButton({super.key, required this.person, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: person.noParents() || person.onlyOneParent(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            callBack();
          },
          borderRadius: BorderRadius.circular(15),
          child: Icon(
            Icons.add_circle_outline_rounded,
            color: Colors.green,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.75),
                blurRadius: 5,
                offset: const Offset(0, 2.5),
              )
            ],
            size: 20,
          ),
        ),
      ),
    );
  }
}

class RemovePersonButton extends StatelessWidget {
  final Person person;
  final VoidCallback callBack;

  const RemovePersonButton({super.key, required this.person, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: person.noParents() && !person.isSource(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            callBack();
          },
          borderRadius: BorderRadius.circular(15),
          child: Icon(
            Icons.remove_circle_outline_rounded,
            color: Colors.red,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.75),
                blurRadius: 5,
                offset: const Offset(0, 2.5),
              )
            ],
            size: 20,
          ),
        ),
      ),
    );
  }
}

class NodeWidget extends StatelessWidget {
  final Person person;
  final VoidCallback addCallback;
  final VoidCallback removeCallback;
  final VoidCallback updateCallback;

  const NodeWidget ({super.key, required this.person, required this.addCallback, required this.removeCallback, required this.updateCallback});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PersonWindow(person: person, onDialogClose: updateCallback);
              },
            );
          },
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12.5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.75),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2.5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 22.5,
                      backgroundImage: person.image,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 62.5,
                    height: 12.5,
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(7.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.75),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        person.name.split(' ').first,
                        style: const TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 3,
          left: 3,
          child: AddParentsButton(
              person: person,
              callBack: () {
                addCallback();
              }
          ),
        ),
        Positioned(
          top: 3,
          right: 3,
          child: RemovePersonButton(
              person: person,
              callBack: () {
                removeCallback();
              }
          ),
        ),
      ],
    );
  }
}

class TreeSeparationController extends StatefulWidget {
  final String title;
  final double initialSliderValue;
  final Function(int value) updateGraphCallBack;

  const TreeSeparationController({Key? key, required this.initialSliderValue, required this.updateGraphCallBack, required this.title}) : super(key: key);

  @override
  State<TreeSeparationController> createState() => _TreeSeparationControllerState();
}

class _TreeSeparationControllerState extends State<TreeSeparationController> {
  late String _title;
  late double _sliderValue;
  late Function(int value) _updateGraphCallBack;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _sliderValue = widget.initialSliderValue;
    _updateGraphCallBack = widget.updateGraphCallBack;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 60,
      child: PopupMenuButton(
        offset: const Offset(0, 0),
        padding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        constraints: const BoxConstraints.tightFor(width: 180),
        child: Row(
          children: [
            const Icon(Icons.account_tree_rounded),
            const Spacer(),
            Text(_title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
          ],
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            padding: EdgeInsets.zero,
            child: StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Slider(
                    value: _sliderValue,
                    min: 10, // the minimum value of the slider
                    max: 500, // the maximum value of the slider
                    divisions: 98, // the number of discrete values
                    label: _sliderValue.round().toString(), // the label of the current value
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                      });
                      _updateGraphCallBack(value.round());
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}

class TreeOrientationController extends StatefulWidget {
  final Function(int) updateOrientationCallback;
  const TreeOrientationController({Key? key, required this.updateOrientationCallback}) : super(key: key);

  @override
  State<TreeOrientationController> createState() => _TreeOrientationControllerState();
}

class _TreeOrientationControllerState extends State<TreeOrientationController> {
  final List<String> _options = [
    'Top-Bottom',
    'Bottom-Top',
    'Left-Right',
    'Right-Left',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 60,
      child: PopupMenuButton(
        offset: const Offset(0, 0),
        padding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        constraints: const BoxConstraints.tightFor(width: 180),
        child: const Row(
          children: [
            Icon(Icons.account_tree_rounded),
            Spacer(),
            Text('Orientation', style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
          ],
        ),
        onSelected: (String newValue) {
          widget.updateOrientationCallback(_options.indexOf(newValue) + 1);
        },
        itemBuilder: (BuildContext context) {
          return _options.map((String value) {
            return PopupMenuItem<String>(
              height: 0,
              padding: EdgeInsets.zero,
              value: value,
              child: SizedBox(
                width: 180,
                height: 40,
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
