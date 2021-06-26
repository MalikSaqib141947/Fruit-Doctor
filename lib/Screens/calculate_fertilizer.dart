import 'package:flutter/material.dart';
import 'package:flutter_doctor/utilities/constants.dart';
import 'package:flutter_doctor/Provider/calculator.dart';
import 'package:provider/provider.dart';

/*class CalculateFertilizer extends StatelessWidget {
  static const String id = "CalculateFertilizer";
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<Test>(builder: (_, test, child) {
                if (test.enable) {
                  print('Controller enabled');
                  controller.value = test.textValue;
                }

                return TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: test.value),
                  onChanged: Provider.of<Test>(context).changeVal,
                );
              }),
              TextButton(
                onPressed: () {
//                  Provider.of<Calculator>(context, listen: false)
//                      .converterStringAdd();
                  Provider.of<Test>(context, listen: false).incrementVal();
                },
                child: Text('Press me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

// ignore: must_be_immutable
class CalculateFertilizer extends StatelessWidget {
  static const String id = "CalculateFertilizer";
  final textController = TextEditingController();
  String fruit;
  CalculateFertilizer({Key key, @required this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Calculate"),
          backgroundColor: appbar_Color,
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "Number of Trees",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Material(
                          color: appbar_Color, // button color
                          child: IconButton(
                              splashColor: primary_Color,
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: 20.5,
                              ),
                              onPressed: () {
                                Provider.of<Calculator>(context, listen: false)
                                    .converterStringSub();
                              }),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 18,
                      ),
                      SizedBox(
                          width: 200,
                          child: Consumer<Calculator>(
                            builder: (_, myProvider, child) {
                              textController.value = myProvider.textValue;
                              return TextFormField(
                                controller: textController,
                                decoration: new InputDecoration(
                                  labelText: "Numbers",
                                  fillColor: Colors.white,
                                  hintText: myProvider.value,

                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                validator: (val) {
                                  if (val.length == 0) {
                                    return "Numbers";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              );
                            },
                          )),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 18,
                      ),
                      ClipOval(
                        child: Material(
                          color: appbar_Color, // button color
                          child: IconButton(
                            splashColor: primary_Color,
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 27.5,
                            ),
                            onPressed:
                                Provider.of<Calculator>(context, listen: false)
                                    .converterStringAdd,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        Provider.of<Calculator>(context, listen: false)
                            .buttonPressed(
                                double.parse(textController.text), fruit);
                        print(textController.text);
                      },
                      color: appbar_Color,
                      textColor: Colors.white,
                      child: Text(
                        "Calculate",
                        style: TextStyle(),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Provider.of<Calculator>(context, listen: false)
                            .buttonClear();
                      },
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      child: Text(
                        "Clear",
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Center(
                child: Text(
                  "Schemes for Fertilization for 1 year",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 30,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<Calculator>(
                        builder: (_, myElevation, child) {
                          return Padding(
                              padding: EdgeInsets.all(2),
                              child: Card(
                                color: Colors.blue[300],
                                elevation: 20,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: ListView(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 20),
                                            child: Text(
                                              "DAP (Kg)",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 20),
                                            child: Text(
                                              "MOP (Kg)",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 20),
                                            child: Text(
                                              "Urea (Kg)",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 50),
                                            child: Text(
                                              myElevation.dap
                                                  .toStringAsFixed(1),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 60),
                                            child: Text(
                                              myElevation.mop1
                                                  .toStringAsFixed(1),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 70),
                                            child: Text(
                                              myElevation.urea1
                                                  .toStringAsFixed(1),
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Consumer<Calculator>(
                        builder: (_, myElevation, child) {
                          return Card(
                            color: Colors.amber[200],
                            elevation: 20,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 6,
                              width: MediaQuery.of(context).size.width - 20,
                              child: ListView(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20),
                                        child: Text(
                                          "10:26:26 (Kg)",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20),
                                        child: Text(
                                          "MOP (Kg)",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 20),
                                        child: Text(
                                          "Urea (Kg)",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 50),
                                        child: Text(
                                          myElevation.fert10.toStringAsFixed(1),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 80),
                                        child: Text(
                                          myElevation.mop2.toStringAsFixed(1),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 80),
                                        child: Text(
                                          myElevation.urea2.toStringAsFixed(1),
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
* InkWell(
                          splashColor: primary_Color, // inkwell color
                          child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                          onTap: Provider.of<Calculator>(context, listen: false)
                              .converterStringAdd,
                        )
* */
