import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jelanco_tracking_system/core/constants/card_size.dart';
import 'package:jelanco_tracking_system/core/constants/shared_size.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:intl/intl.dart' as intl;

class SubmissionLocationDialog extends StatefulWidget {
  final TaskSubmissionModel taskSubmissionModel;

  const SubmissionLocationDialog({
    super.key,
    required this.taskSubmissionModel,
  });

  @override
  State<SubmissionLocationDialog> createState() =>
      _SubmissionLocationDialogState();
}

class _SubmissionLocationDialogState extends State<SubmissionLocationDialog> {
  late GoogleMapController _mapController;
  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    bool isSameLocation = widget.taskSubmissionModel.tsStartLatitude ==
                widget.taskSubmissionModel.tsEndLatitude &&
            widget.taskSubmissionModel.tsStartLongitude ==
                widget.taskSubmissionModel.tsEndLongitude
        ? true
        : false;

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(SharedSize.alertDialogBorderRadius)),
      ),
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(SharedSize.alertDialogBorderRadius),
        child: Stack(
          children: [
            SizedBox(
              width: double.maxFinite,
              height: 450, // You can adjust this height
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                double.parse(widget
                                    .taskSubmissionModel.tsStartLatitude!),
                                double.parse(widget
                                    .taskSubmissionModel.tsStartLongitude!)),
                            zoom: 17,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            addMarker(
                                'check-in',
                                LatLng(
                                    double.parse(widget
                                        .taskSubmissionModel.tsStartLatitude!),
                                    double.parse(widget.taskSubmissionModel
                                        .tsStartLongitude!)),
                                widget.taskSubmissionModel.createdAt!,
                                _markers);
                            // if (widget.taskSubmissionModel.tsActualEndTime != null) {
                            //   addMarker(
                            //       'check-out',
                            //       LatLng(
                            //           double.parse(
                            //               widget.taskSubmissionModel.tsEndLatitude!),
                            //           double.parse(widget
                            //                   .taskSubmissionModel.tsEndLongitude!) +
                            //               (isSameLocation ? 0.00001 : 0)),
                            //       widget.taskSubmissionModel.tsActualEndTime!,
                            //       _markers);
                            // }
                          },
                          markers: _markers.values.toSet(),
                        ),
                        // Text('مفتاح الخارطة'),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('موقع التسليم'.tr(args: [
                                    // intl.DateFormat('H:mm').format(
                                    //     DateTime.parse(widget.taskSubmissionModel.createdAt.toString()))
                                  ])),
                                ],
                              ),
                              // const SizedBox(height: 8),
                              // Row(
                              //   children: [
                              //     const Icon(
                              //       Icons.location_pin,
                              //       color: Colors.red,
                              //     ),
                              //     const SizedBox(width: 8),
                              //     Text('موقع الإنتهاء'.tr(args: [
                              //       // widget.taskSubmissionModel.tsActualEndTime != null
                              //       //     ? intl.DateFormat('H:mm').format(
                              //       //     DateTime.parse(widget.taskSubmissionModel.tsActualEndTime.toString()))
                              //       //     : ''
                              //     ])),
                              //   ],
                              // ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // The close button at the top-right corner
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close, color: Colors.red), // Close icon
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addMarker(
    String id,
    LatLng latLng,
    DateTime time,
    Map<String, Marker> markersMap,
  ) {
    var marker = Marker(
      markerId: MarkerId(id),
      position: latLng,
      infoWindow: InfoWindow(
          title: id == 'check-in' ? 'موقع التسليم' : 'موقع الانتهاء',
          snippet:
              'الوقت: ${intl.DateFormat('H:mm').format(DateTime.parse(time.toString()))}'
                  .tr(args: [])),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        id == 'check-in' ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
      ),
    );
    print('add marker');
    markersMap[id] = marker;
    setState(() {});
  }
}
