import 'dart:convert';

import 'package:flutter/material.dart';

import 'db/DBHelper.dart';
import 'model/savedcardsmodel.dart';

class savedCards extends StatefulWidget {
  const savedCards({super.key});

  @override
  State<savedCards> createState() => _savedCardsState();
}

class _savedCardsState extends State<savedCards> {
  var db = DBHelper();
  bool isloading = true;
  bool isdata = true;
  List litems = [];
  savedcardsmodel? Savedcardsmodel;

  @override
  void initState() {
    getallcarddetails();
    super.initState();
  }

  Future<void> getallcarddetails() async {
    var db = DBHelper();

    List checkcardsearch = await db.Getallcarddata();
    litems = checkcardsearch;

    setState(() {
      isloading = false;
      isdata = true;
    });

    print("checkcardsearch = $checkcardsearch");

    print("==== ${litems[0]['cardHoldername']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Cards"),),

      body: isloading? Center(
        child: Visibility(
          visible: isloading,
          child: const CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ) : isdata ? ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: litems.length,
          itemBuilder: (context, index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              margin: const EdgeInsets.all(5),
               color: const Color(0xff123456),
              child: Column(
                children: [

                  Container(
                      margin: const EdgeInsets.only(left: 12,top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          litems[index]['cardNumber']!,
                          style: const TextStyle(
                              fontFamily: 'Lato',fontSize: 20,
                              color: Colors.white),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              litems[index]['cardHoldername']!,
                              style: const TextStyle(
                                fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'champanebold',
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              litems[index]['expirydate']!,
                              style: const TextStyle(
                                fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'champanebold',
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }) : Center(
        child: Visibility(
            visible: !isdata,
            child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Center(child: Text("No data available here.",style: TextStyle(fontSize: 15,color: Colors.red,),)))
        ),
      ),

    );
  }
}
