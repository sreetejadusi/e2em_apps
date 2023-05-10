import 'package:flutter/material.dart';

import '../index_files.dart';

void showDropdownSearchDialog(
    {required BuildContext context,
    required List<String> items,
    required bool addEnabled,
    bool searchEnabled = true,
    required Function(String) onChanged}) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn,
            child: SearchDialog(
              context: context,
              hintText: 'Search',
              items: items,
              addEnabled: addEnabled,
              searchEnabled: searchEnabled,
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ));
}

class SearchDialog extends StatefulWidget {
  final BuildContext context;
  final String hintText;
  final List<String> items;
  final bool addEnabled;
  final bool searchEnabled;
  final Function(String) onChanged;
  const SearchDialog(
      {super.key,
      required this.context,
      required this.hintText,
      required this.items,
      required this.addEnabled,
      required this.searchEnabled,
      required this.onChanged});
  @override
  State createState() => SearchDialogState();
}

class SearchDialogState extends State<SearchDialog> {
  String _searchText = "";
  String? addFieldText;
  List<String> itemsData = [];
  final TextEditingController _searchQuery = TextEditingController();
  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    _SearchListState();
    itemsData = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(largeRadius))),
        color: Theme.of(context).cardColor,
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(largeRadius + 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.searchEnabled) ...[
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchQuery,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hintText,
                        ),
                      ),
                    ),
                    /*IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 15,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchQuery.clear();
                      });
                    },
                  ),*/
                    if (widget.addEnabled) ...[
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          /* showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  style: TextStyle(),
                                  cursorColor: cursorColor,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Add Text"),
                                  onChanged: (value) {
                                    setState(() {
                                      addFieldText = value;
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () {}, child: Text('Ok'))
                                ],
                              )
                            ],
                          ),
                        );*/
                        },
                      )
                    ]
                  ],
                ),
              ],
              Expanded(
                child: Scrollbar(
                  scrollbarOrientation: ScrollbarOrientation.left,
                  thumbVisibility: true,
                  child: ListView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: <Widget>[
                        for (var i = 0; i < itemsData.length; i++) ...[
                          if (itemsData[i]
                              .toString()
                              .toLowerCase()
                              .contains(_searchText.toLowerCase().trim())) ...[
                            dropdownOptionTile(
                                context: context,
                                onChanged: () {
                                  widget.onChanged(itemsData[i]);
                                  Navigator.pop(context);
                                },
                                text: itemsData[i]),
                            /*ListTile(
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  itemsData[i].toString(),
                                  maxLines: 2,
                                ),
                              ),
                              onTap: () {
                                widget.onChanged(itemsData[i]);
                                Navigator.pop(context);
                              },
                            )*/
                          ]
                        ]
                      ]),
                ),
              ),
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
    );
  }
}
