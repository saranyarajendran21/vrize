import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:vrize/db/DBHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vrize/savedCards.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var db = DBHelper();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FlipCardController flipCardController = FlipCardController();

  @override
  void initState() {
    super.initState();

    Stripe.publishableKey = "pk_test_51HT0szCIqBgZw96ZMO7MooFy2bI0hGEtzKWTj8HDQoANUYy9EFT60sfmcIpW8cScwKdvbC00ez0m0t61wK6aXzRP00GTeenlTD";
    Stripe.merchantIdentifier = 'your_merchant_identifier'; // Only required for Apple Pay on iOS
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      final CardDetails testCard = CardDetails(
        number: _cardNumberController.text,
        expirationMonth: int.parse(_expiryDateController.text.split("/")[0]),
        expirationYear: int.parse(_expiryDateController.text.split("/")[1]),
        cvc: _cvvController.text,
      );

      Map<String, dynamic> newrow = {
        db.cardHoldername: _holderNameController.text,
        db.cardNumber: _cardNumberController.text,
        db.expirydate: _expiryDateController.text,
        db.cvvNumber: _cvvController.text,
      };
      await db.saveCarddetails(newrow);

      Fluttertoast.showToast(
        msg: "Card details are saved Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      print("card details = $testCard");
      try {
        final PaymentMethod paymentMethod = await Stripe.instance.createPaymentMethod(
            params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(name: _holderNameController.text),
            ))
            );

        // Save the paymentMethod.id to your server/database
        print('Payment Method ID: ${paymentMethod.id}');

        // Handle success and navigate to the next screen or perform any other actions
      } catch (e) {
        // Handle errors
        print('Error creating Payment Method: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe',style: TextStyle(fontSize: 25,color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
/*
            FlipCard(
                fill: Fill.fillFront,
                direction: FlipDirection.HORIZONTAL,
                controller: flipCardController,
                onFlip: () {
                  print('Flip');
                },
                flipOnTouch: false,
                onFlipDone: (isFront) {
                  print('isFront: $isFront');
                },
                front: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildCreditCard(
                    color: Colors.blueAccent,
                    cardExpiration: cardExpiryDateController.text.isEmpty
                        ? "08/2022"
                        : cardExpiryDateController.text,
                    cardHolder: cardHolderNameController.text.isEmpty
                        ? "Card Holder"
                        : cardHolderNameController.text.toUpperCase(),
                    cardNumber: cardNumberController.text.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : cardNumberController.text,
                  ),
                ),
                back: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 4.0,
                    color: kDarkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      height: 230,
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 0),
                          const Text(
                            'https://www.paypal.com',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                          Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          CustomPaint(
                            painter: MyPainter(),
                            child: SizedBox(
                              height: 35,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    cardCvvController.text.isEmpty
                                        ? "322"
                                        : cardCvvController.text,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 21,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
*/
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _holderNameController,
                    decoration: const InputDecoration(labelText: 'Card Holder Name'),
                    keyboardType: TextInputType.text,

                    validator: (value) {
                      String pattern = r'^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$';
                      RegExp regex = RegExp(pattern);
                      if (value!.isNotEmpty) {
                        if (regex.hasMatch(value)) {
                        } else {
                          return 'Enter a valid name';
                        }
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      String pattern = r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$';
                      RegExp regex = RegExp(pattern);
                      if (value!.isNotEmpty) {
                        if (regex.hasMatch(value)) {
                        } else {
                          return 'Enter a valid card number';
                        }
                      } else {
                        return null;
                      }
                    },

                  ),
                  TextFormField(
                    controller: _expiryDateController,
                    maxLength:5,
                    decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if(value.length == 2) _expiryDateController.text += "/"; //<-- Automatically show a '/' after dd
                      // donation.date = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid expiry date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    validator: (value) {

                      String pattern = r'^[0-9]{3,4}$';
                      RegExp regex = RegExp(pattern);
                      if (value!.isNotEmpty) {
                        if (regex.hasMatch(value)) {} else {
                          return 'Enter a valid cvv number';
                        }
                      } else {
                        return null;
                      }
                    }
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _saveCard();
                      _holderNameController.text = '';
                      _cardNumberController.text = '';
                      _expiryDateController.text = '';
                      _cvvController.text = '';
                    },
                    child: const Text('Save Card'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const savedCards()));
        },
        icon: const Icon(Icons.save),
        label: const Text("Saved Cards"),
      ),
    );
  }
}