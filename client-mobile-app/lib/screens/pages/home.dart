import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:grab_clone/api/CustomerService.dart';
import 'package:grab_clone/api/SocketApi.dart';
import 'package:grab_clone/constants.dart';
import 'package:grab_clone/models/Booking.dart';
import 'package:grab_clone/models/Customer.dart';
import 'package:grab_clone/models/TopAddress.dart';
import 'package:grab_clone/models/TopHistory.dart';
import 'package:grab_clone/screens/book/driver_tracking.dart';
import 'package:grab_clone/widgets/location_list_item.dart';
import 'package:grab_clone/widgets/vehicle_chosen_button.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:relative_time/relative_time.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;

import '../../helpers/helper.dart';
import '../../models/BookingStatus.dart';
import '../../widgets/skeletons/skeleton_location_list_item.dart';
import '../place_picker.dart';

class Location {
  final String name;
  final String address;

  Location({required this.name, required this.address});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.scrollController}) : super(key: key);
  final ScrollController? scrollController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Location> items = [];

  Future<List<TopAddress>> _getTop5Address() async {
    var myInfo = await getStoredData();
    final user = myInfo["user"] as CustomerModel;

    final res = await CustomerService.getTop5Address(user.phoneNumber ?? "");
    if (res.statusCode == 200) {
      try {
        List jsonRes = json.decode(res.body);
        var data = jsonRes.map((data) => TopAddress.fromMap(data)).toList();
        return data;
      } catch (e) {
        return [];
      }
    } else {
      throw Exception("Error");
    }
  }

  Future<List<BookingModel>> _getTopHistory() async {
    var myInfo = await getStoredData();
    final user = myInfo["user"] as CustomerModel;

    final res = await CustomerService.getHistory(user.phoneNumber ?? "");

    if (res.statusCode == 200) {
      List jsonRes = json.decode(res.body);
      try {
        var data = jsonRes.map((data) => BookingModel.fromMap(data)).toList();
        return data;
      } catch (e) {
        return [];
      }
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    SocketApi.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext parentContext) {
    final theme = Theme.of(parentContext);
    final navigator = Navigator.of(parentContext);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: theme.primaryColor.withOpacity(.7),
                height: MediaQuery.of(parentContext).size.height * 0.22,
                width: MediaQuery.of(parentContext).size.width,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: kToolbarHeight,
                        left: layoutMedium + layoutSmall,
                        right: layoutMedium + layoutSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("home_top_text_1".tr(),
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: layoutSmall),
                        Text("home_top_text_2".tr(),
                            style: theme.textTheme.bodyMedium)
                      ],
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: layoutXXLarge + layoutMedium,
                    left: layoutMedium,
                    right: layoutMedium),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      VehicleChosenButton(
                        image: "assets/images/motorbike.png",
                        title: "Xe máy",
                        vehicleType: "2",
                      ),
                      VehicleChosenButton(
                        image: "assets/images/car.png",
                        title: "4 chỗ",
                        vehicleType: "4",
                      ),
                      VehicleChosenButton(
                        image: "assets/images/van.png",
                        title: "7 chỗ",
                        vehicleType: "7",
                      ),
                    ]),
              ),
              const SizedBox(height: layoutSmall),
              Expanded(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                        height: MediaQuery.of(parentContext).size.height * 0.5,
                        child: FutureBuilder<List<BookingModel>>(
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (_, i) {
                                    return Shimmer.fromColors(
                                      baseColor: baseLoadingColor,
                                      highlightColor: highlightLoadingColor,
                                      child: const SkeletonLocationListItem(),
                                    );
                                  },
                                  separatorBuilder: (_, __) => Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: layoutMedium),
                                    color: Colors.grey.withOpacity(.4),
                                  ),
                                );
                              }

                              var history = snapshot.data;
                              if (snapshot.hasData) {
                                if (history!.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: const Text(
                                      "Chưa có lịch sử chuyến đi",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  );
                                } else {
                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount:
                                        history.length > 5 ? 5 : history.length,
                                    itemBuilder: (_, i) {
                                      if (history[i].updatedAt == null) {
                                        return Container();
                                      }

                                      var f = NumberFormat.currency(
                                          locale: "vi_VN");
                                      var outputFormat =
                                          DateFormat('hh:mm dd/MM/yyyy');
                                      return LocationListItem(
                                          onTap: () {
                                            var driver = history[i].driver;
                                            nb_utils.showBottomSheetOrDialog(
                                                context: context,
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Column(children: [
                                                      Text(
                                                        "Thông tin chi tiết",
                                                        style: nb_utils
                                                            .primaryTextStyle(
                                                                size: 16,
                                                                weight: nb_utils
                                                                    .fontWeightBoldGlobal),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      const Divider(
                                                        height: 2,
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                      Container(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Số điện thoại tài xế",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  Text(
                                                                    driver!
                                                                        .phoneNumber!,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Tên tài xế",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  Text(
                                                                    driver!
                                                                        .fullName!,
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Loại xe",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  Builder(builder:
                                                                      (context) {
                                                                    const vehicleTypeMap =
                                                                        {
                                                                      "2":
                                                                          "Xe máy",
                                                                      "4":
                                                                          "Xe 4 chỗ",
                                                                      "7":
                                                                          "Xe 7 chỗ"
                                                                    };

                                                                    return Text(
                                                                        vehicleTypeMap[
                                                                            driver.vehicleType!]!);
                                                                  }),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Điểm đón",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  nb_utils
                                                                      .ReadMoreText(
                                                                    history[i]
                                                                            ?.pickupAddrFull ??
                                                                        "",
                                                                    trimLength:
                                                                        30,
                                                                    trimCollapsedText:
                                                                        " ... đọc thêm",
                                                                    trimExpandedText:
                                                                        " thu gọn",
                                                                    colorClickableText:
                                                                        Colors
                                                                            .grey
                                                                            .shade500,
                                                                    trimLines:
                                                                        2,
                                                                    trimMode: nb_utils
                                                                        .TrimMode
                                                                        .Line,
                                                                  ).flexible(),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Điểm đến",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  nb_utils
                                                                      .ReadMoreText(
                                                                    history[i]
                                                                            ?.destAddrFull ??
                                                                        "",
                                                                    trimLength:
                                                                        30,
                                                                    trimCollapsedText:
                                                                        " ... đọc thêm",
                                                                    trimExpandedText:
                                                                        " thu gọn",
                                                                    colorClickableText:
                                                                        Colors
                                                                            .grey
                                                                            .shade500,
                                                                    trimLines:
                                                                        2,
                                                                    trimMode: nb_utils
                                                                        .TrimMode
                                                                        .Line,
                                                                  ).flexible(),
                                                                ],
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Khoảng cách",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  nb_utils
                                                                      .ReadMoreText(
                                                                    "${history[i]?.distance!} km",
                                                                    trimLength:
                                                                        30,
                                                                    trimCollapsedText:
                                                                        " ... đọc thêm",
                                                                    trimExpandedText:
                                                                        " thu gọn",
                                                                    colorClickableText:
                                                                        Colors
                                                                            .grey
                                                                            .shade500,
                                                                    trimLines:
                                                                        2,
                                                                    trimMode: nb_utils
                                                                        .TrimMode
                                                                        .Line,
                                                                  ).flexible(),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Giá: ",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  Text(f.format(
                                                                          double.parse(
                                                                              history[i].price!)))
                                                                      .flexible()
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Ngày đặt xe: ",
                                                                    style: nb_utils
                                                                        .boldTextStyle(),
                                                                  ).expand(),
                                                                  Text(outputFormat.format(history[
                                                                              i]
                                                                          .updatedAt!
                                                                          .toLocal()))
                                                                      .flexible()
                                                                ],
                                                              ),
                                                            ]),
                                                      )
                                                    ])),
                                                bottomSheetDialog: nb_utils
                                                    .BottomSheetDialog
                                                    .BottomSheet);
                                          },
                                          title: history[i].destAddrFull!,
                                          subtitle: history[i]
                                              .updatedAt!
                                              .relativeTimeLocale(
                                                  const Locale('vi')));
                                    },
                                    separatorBuilder: (_, __) => Container(
                                      height: 1,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: layoutMedium),
                                      color: Colors.grey.withOpacity(.4),
                                    ),
                                  );
                                }
                              }

                              return Container();
                            },
                            future: _getTopHistory())),
                    const SizedBox(height: layoutMedium),
                  ]),
                ),
              ))
            ],
          ),
          Positioned(
            top: MediaQuery.of(parentContext).size.height * 0.22 -
                (kToolbarHeight + layoutMedium) / 2,
            left: layoutMedium,
            right: layoutMedium,
            child: GestureDetector(
              onTap: () async {
                GeoPoint? pickupGeo = await getPickupGeoPoint();
                var p = await navigator.push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PlacePicker(
                          isPickUpAddr: true,
                          initPosition: pickupGeo ?? pickupGeo,
                        ),
                    transitionDuration: shortDuration,
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    }));
                if (p != null) {
                  await savePickupGeoPoint(p);
                  if (!mounted) return;
                  setState(() {});
                }
              },
              child: Container(
                  height: kToolbarHeight + layoutMedium,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(borderRadiusSmall),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: layoutMedium),
                        child: Icon(
                          Icons.location_on,
                          color: theme.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: getPickupAddress(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                      right: layoutMedium),
                                  child: Text(snapshot.data.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      maxLines: 2,
                                      style: theme.textTheme.titleLarge!
                                          .copyWith(color: Colors.black)),
                                );
                              }
                              return Text("home_search_bar_hint".tr(),
                                  style: theme.textTheme.titleLarge!
                                      .copyWith(color: Colors.grey[500]));
                            }),
                      ),
                    ],
                  )),
            ),
          ),
          FutureBuilder<BookingModel?>(
              future: getCurrentBooking(),
              builder: (context, snapshot) {
                log("snapshot.hasData: ${snapshot.hasData}",
                    name: "HomeScreen");
                if (snapshot.hasData) {
                  SocketApi().ins.on("booking_updated", (data) async {
                    if (data == null) {
                      return;
                    }
                    BookingModel req = BookingModel.fromMap(data);
                    switch (req.status) {
                      case BookingStatus.FAILED:
                        EasyLoading.showError(
                            "Không tìm được tài xế. Thử lại sau");
                        await clearCurrentBooking();
                        setState(() {
                          SocketApi().ins.off("booking_updated");
                        });
                        break;
                      case BookingStatus.DONE:
                        await clearCurrentBooking();
                        await EasyLoading.showInfo("Đã hoàn thành chuyến đi");
                        setState(() {
                          SocketApi().ins.off("booking_updated");
                        });
                        break;
                    }
                  });

                  return Positioned(
                      left: layoutMedium,
                      right: layoutMedium,
                      bottom: layoutMedium,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      const DriverTrackingScreen()))
                              .then((value) => setState(() {}));
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadiusSmall),
                                side: BorderSide(
                                    color: Colors.grey.withOpacity(.4)))),
                        child: Text("Theo dõi vị trí tài xế",
                            style: Theme.of(context).textTheme.titleLarge!),
                      ));
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }
}
