import 'package:flutter/material.dart';

class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Container(
//                color: kpcol,
                height: 120,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
//                  color: kpcol,
                ),
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: Color(0xFF6E41B7),
                  indicatorWeight: 0.1,
                  tabs: <Widget>[
                    Tab(
                        icon: Icon(
                      Icons.dashboard,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.notifications,
                      size: 40,
                    )),
                    Tab(
                        icon: Icon(
                      Icons.input,
                      size: 40,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



