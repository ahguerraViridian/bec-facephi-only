import 'package:flutter/material.dart';

class SelphIDList extends StatelessWidget {
  SelphIDList(
      this._map, this._heightScreenPercentage, this._widthScreenPercentage);

  Map<String, dynamic> _map;
  double _heightScreenPercentage;
  double _widthScreenPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey[200],
      ),
      child: _map != null && _map.length > 1
          ? Column(
              children: List<Widget>.generate(
                _map.length,
                (int index) {
                  String key = _map.keys.elementAt(index);
                  return
                      // Container();

                      Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("$key"),
                        subtitle: new Text(
                          "${_map[key]}",
                        ),
                      ),
                      new Divider(
                        height: 2.0,
                      )
                    ],
                  );
                },
              ),
            )
          : Container(),
    );
  }
}
