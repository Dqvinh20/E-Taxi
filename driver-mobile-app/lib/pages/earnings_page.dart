import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grab_eat_ui/api/DriverService.dart';
import 'package:grab_eat_ui/models/Driver.dart';
import 'package:grab_eat_ui/models/DriverHistory.dart';
import 'package:grab_eat_ui/theme/colors.dart';
import 'package:grab_eat_ui/utils/helper.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;
import 'package:relative_time/relative_time.dart';

class EarningsPage extends StatefulWidget {
  @override
  _EarningsPageState createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  Future<List<DriverHistory>> _getTopHistory() async {
    final res = await DriverService.getHistory();
    if (res.statusCode == 200) {
      List jsonRes = json.decode(res.body);
      try {
        var data = jsonRes.map((data) => DriverHistory.fromMap(data)).toList();
        return data;
      } catch (e) {
        e.printInfo();
        return [];
      }
    } else {
      throw Exception("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        searchBar: false,
        title: Text("Lịch sử"),
      ),
      backgroundColor: white,
      body: Container(
          child: FutureBuilder<List<DriverHistory>>(
        future: _getTopHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var history = snapshot.data;
            var outputFormat = DateFormat('dd/MM/yyyy');
            return ListView.builder(
                itemCount: history!.length,
                itemBuilder: (context, i) {
                  var f = NumberFormat.currency(locale: "vi_VN");
                  var realIncome = history[i].totalEarning! * 0.7;
                  return GFAccordion(
                      showAccordion: true,
                      titleChild: Row(
                        children: [
                          Text(outputFormat.format(history[i].bookingDate!))
                              .expand(),
                          Text(f.format(history[i].totalEarning))
                              .marginOnly(right: 8),
                        ],
                      ),
                      contentChild: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: history[i].count,
                                itemBuilder: (context, j) {
                                  var bookData = history[i].bookings?[j];
                                  var customer = bookData?.customer;

                                  return GFListTile(
                                    color: Colors.grey.shade100,
                                    shadow: nb_utils
                                        .defaultBoxShadow(
                                            shadowColor:
                                                Colors.black.withAlpha(1))
                                        .first,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 0),
                                    description: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Điểm đến",
                                              style: nb_utils.boldTextStyle(),
                                            ).expand(),
                                            nb_utils.ReadMoreText(
                                              bookData?.destAddrFull ?? "",
                                              trimLength: 30,
                                              trimCollapsedText:
                                                  " ... đọc thêm",
                                              trimExpandedText: " thu gọn",
                                              colorClickableText:
                                                  Colors.grey.shade500,
                                              trimLines: 2,
                                              trimMode: nb_utils.TrimMode.Line,
                                            ).flexible(),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Khoảng cách",
                                              style: nb_utils.boldTextStyle(),
                                            ).expand(),
                                            nb_utils.ReadMoreText(
                                              "${bookData?.distance!} km",
                                              trimLength: 30,
                                              trimCollapsedText:
                                                  " ... đọc thêm",
                                              trimExpandedText: " thu gọn",
                                              colorClickableText:
                                                  Colors.grey.shade500,
                                              trimLines: 2,
                                              trimMode: nb_utils.TrimMode.Line,
                                            ).flexible(),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Giá: ",
                                              style: nb_utils.boldTextStyle(),
                                            ).expand(),
                                            Text(f.format(
                                                    history[i].totalEarning))
                                                .flexible()
                                          ],
                                        ),
                                      ],
                                    ),
                                    titleText: "${customer?.fullName}",
                                    subTitleText: bookData?.updatedAt!
                                        .relativeTimeLocale(const Locale('vi')),
                                  );
                                }),
                            Row(
                              children: [
                                Text(
                                  "Phần trăm khấu trừ",
                                  style: nb_utils.boldTextStyle(),
                                ).expand(),
                                Text("-30%")
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Thực nhận",
                                  style: nb_utils.boldTextStyle(),
                                ).expand(),
                                Text(f.format(realIncome))
                              ],
                            ),
                          ],
                        ),
                      ));
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }

  Widget getBody() {
    return Center(
      child: Text(
        "Earnings Page",
        style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: black),
      ),
    );
  }
}
