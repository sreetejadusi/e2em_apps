import 'package:flutter/material.dart';

import '../index_files.dart';

void showDropdownNormalDialog(
    {required BuildContext context,
    required List<String> items,
    required Function(String) onChanged}) {
  showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) => AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      curve: Curves.bounceIn,
      child: NormalDialog(
        context: context,
        items: items,
        onChanged: (value) {
          onChanged(value);
        },
      ),
    ),
  );
}

class NormalDialog extends StatefulWidget {
  final BuildContext context;
  final List<String> items;
  final Function(String) onChanged;
  const NormalDialog(
      {super.key,
      required this.context,
      required this.items,
      required this.onChanged});
  @override
  State createState() => NormalDialogState();
}

class NormalDialogState extends State<NormalDialog> {
  List<String> itemsData = [];

  @override
  void initState() {
    itemsData = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(largeRadius))),
            color: Theme.of(context).cardColor,
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(largeRadius + 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < itemsData.length; i++) ...[
                          dropdownOptionTile(
                              context: context,
                              onChanged: () {
                                widget.onChanged(itemsData[i]);
                                Navigator.pop(context);
                              },
                              text: itemsData[i]),
                          /* ListTile(
                            title: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                itemsData[i].toString(),
                                maxLines: 1,
                              ),
                            ),
                            onTap: () {
                              widget.onChanged(itemsData[i]);
                              Navigator.pop(context);
                            },
                          )*/
                        ]
                      ]),
                  FloatingActionButton.small(
                    elevation: 0,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
