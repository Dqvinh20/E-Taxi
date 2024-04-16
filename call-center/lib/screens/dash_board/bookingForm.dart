import 'package:easy_debounce/easy_debounce.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:web/model/TopHistory.dart';

import '../../model/BookingReq.dart';
import '../../model/Location.dart';

class BookingFormController {
  VoidCallback clear = () {};
  void Function(TopHistory req) insertBookReq = (TopHistory req) {};
  BookingReq bookingReq = BookingReq(
      destAddr: Location(),
      phoneNumber: '',
      pickupAddr: Location(),
      status: '',
      vehicleType: '');

  void dispose() {}
}

class BookingForm extends StatefulWidget {
  final Function onPhoneNumberChanged;

  final BookingFormController controller;

  const BookingForm({
    Key? key,
    required this.onPhoneNumberChanged,
    required this.controller,
  }) : super(key: key);
  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  void saveChildCallback() {
    print("submit");
  }

  String vehicleType = '2';
  TextEditingController phoneController = TextEditingController();

  TextEditingController pickupNoText = TextEditingController();
  TextEditingController pickupStreetText = TextEditingController();
  TextEditingController pickupWardText = TextEditingController();
  TextEditingController pickupDistrictText = TextEditingController();
  TextEditingController pickupCityText = TextEditingController();

  TextEditingController destNoText = TextEditingController();
  TextEditingController destStreetText = TextEditingController();
  TextEditingController destWardText = TextEditingController();
  TextEditingController destDistrictText = TextEditingController();
  TextEditingController destCityText = TextEditingController();

  @override
  void initState() {
    super.initState();
    BookingFormController controller = widget.controller;
    controller.clear = () => setState(() => {
          pickupNoText.text = "",
          pickupStreetText.text = "",
          pickupWardText.text = "",
          pickupDistrictText.text = "",
          pickupCityText.text = "",
          destNoText.text = "",
          destStreetText.text = "",
          destWardText.text = "",
          destDistrictText.text = "",
          destCityText.text = "",
          vehicleType = "2",
        });
    controller.insertBookReq = (TopHistory req) => {
          phoneController.text = req.phoneNumber ?? "",
          pickupNoText.text = req.pickupAddr?.homeNo ?? "",
          pickupStreetText.text = req.pickupAddr?.street ?? "",
          pickupWardText.text = req.pickupAddr?.ward ?? "",
          pickupDistrictText.text = req.pickupAddr?.district ?? "",
          pickupCityText.text = req.pickupAddr?.city ?? "",
          destNoText.text = req.destAddr?.homeNo ?? "",
          destStreetText.text = req.destAddr?.street ?? "",
          destWardText.text = req.destAddr?.ward ?? "",
          destDistrictText.text = req.destAddr?.district ?? "",
          destCityText.text = req.destAddr?.city ?? "",
          controller.bookingReq.pickupAddr = req.pickupAddr!,
          controller.bookingReq.destAddr = req.destAddr!,
          controller.bookingReq.phoneNumber = req.phoneNumber!,
          setState(() => {
                vehicleType = req.vehicleType!,
                controller.bookingReq.vehicleType = vehicleType,
              })
        };

    phoneController.addListener(() {
      controller.bookingReq.phoneNumber = phoneController.text;
    });
    pickupNoText.addListener(() {
      controller.bookingReq.pickupAddr.homeNo = pickupNoText.text;
    });
    pickupStreetText.addListener(() {
      controller.bookingReq.pickupAddr.street = pickupStreetText.text;
    });
    pickupWardText.addListener(() {
      controller.bookingReq.pickupAddr.ward = pickupWardText.text;
    });
    pickupDistrictText.addListener(() {
      controller.bookingReq.pickupAddr.district = pickupWardText.text;
    });
    pickupCityText.addListener(() {
      controller.bookingReq.pickupAddr.city = pickupCityText.text;
    });
    destNoText.addListener(() {
      controller.bookingReq.destAddr.homeNo = destNoText.text;
    });
    destStreetText.addListener(() {
      controller.bookingReq.destAddr.street = destStreetText.text;
    });
    destWardText.addListener(() {
      controller.bookingReq.destAddr.ward = destWardText.text;
    });
    destDistrictText.addListener(() {
      controller.bookingReq.destAddr.district = destDistrictText.text;
    });
    destCityText.addListener(() {
      controller.bookingReq.destAddr.city = destCityText.text;
    });
    phoneController.text = "0972360214";
  }

  @override
  void dispose() {
    EasyDebounce.cancel("phoneController");
    phoneController.dispose();
    pickupNoText.dispose();
    pickupStreetText.dispose();
    pickupWardText.dispose();
    pickupDistrictText.dispose();
    pickupCityText.dispose();
    destNoText.dispose();
    destStreetText.dispose();
    destWardText.dispose();
    destDistrictText.dispose();
    destCityText.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Customize the padding value
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Customize background color
        borderRadius: BorderRadius.circular(10.0), // Customize border radius
      ),
      child: Form(
        child: Column(
          children: [
            // From and To fields for the first row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: phoneController,
                    onChanged: (text) {
                      EasyDebounce.debounce(
                          'phoneController', // <-- An ID for this particular throttler
                          const Duration(
                              milliseconds: 500), // <-- The throttle duration
                          () => widget.onPhoneNumberChanged(
                              text) // <-- The target method
                          );
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintText: 'Enter phone number',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Vehicle type radio buttons
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Bike'),
                    value: '2 ',
                    groupValue:
                        vehicleType, // Use the variable that holds the selected value
                    onChanged: (value) {
                      setState(() {
                        vehicleType = value as String;
                        widget.controller.bookingReq.vehicleType = vehicleType;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('4-Car'),
                    value: '4',
                    groupValue:
                        vehicleType, // Use the variable that holds the selected value
                    onChanged: (value) {
                      setState(() {
                        vehicleType =
                            value as String; // Update the selected value
                        widget.controller.bookingReq.vehicleType = vehicleType;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('7-Car'),
                    value: '7',
                    groupValue:
                        vehicleType, // Use the variable that holds the selected value
                    onChanged: (value) {
                      setState(() {
                        vehicleType =
                            value as String; // Update the selected value
                        widget.controller.bookingReq.vehicleType = vehicleType;
                      });
                    },
                  ),
                ),
              ],
            ),
            // From and To fields for the second row

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pickupNoText,
                    decoration: const InputDecoration(
                      labelText: 'Pick up Home No.',
                      hintText: 'Pick up Home No.',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: destNoText,
                    decoration: const InputDecoration(
                      labelText: 'Destination Home No.',
                      hintText: 'Destination Home No.',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pickupStreetText,
                    decoration: InputDecoration(
                      label: Text("Pick up Street"),
                      hintText: 'Pick up street',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: destStreetText,
                    decoration: InputDecoration(
                      label: Text("Destination Street"),
                      hintText: 'Destination Street   ',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pickupWardText,
                    decoration: InputDecoration(
                      label: Text("Pick up Ward"),
                      hintText: 'Pick up ward',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: destWardText,
                    decoration: InputDecoration(
                      label: Text("Destination Ward"),
                      hintText: 'Destination ward',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pickupDistrictText,
                    decoration: InputDecoration(
                      label: Text("Pick up District"),
                      hintText: 'Pick up district',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: destDistrictText,
                    decoration: InputDecoration(
                      label: Text("Destination District"),
                      hintText: 'Destination district',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: pickupCityText,
                    decoration: InputDecoration(
                      label: Text("Pick up City"),
                      hintText: 'Pick up city',
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    controller: destCityText,
                    decoration: InputDecoration(
                      label: Text("Destination City"),
                      hintText: 'Destination city',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
