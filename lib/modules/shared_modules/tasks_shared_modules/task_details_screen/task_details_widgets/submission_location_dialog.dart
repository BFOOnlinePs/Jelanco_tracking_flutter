import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';
import 'package:intl/intl.dart' as intl;

class SubmissionLocationDialog extends StatefulWidget {
  final TaskSubmissionModel taskSubmissionModel;

  const SubmissionLocationDialog(
      {super.key, required this.taskSubmissionModel});

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
      content: Container(
        width: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          double.parse(
                              widget.taskSubmissionModel.tsStartLatitude!),
                          double.parse(
                              widget.taskSubmissionModel.tsStartLongitude!)),
                      zoom: 17,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                      addMarker(
                          'check-in',
                          LatLng(
                              double.parse(widget.taskSubmissionModel
                                  .tsStartLatitude!) as double,
                              double.parse(widget.taskSubmissionModel
                                  .tsStartLongitude!) as double),
                          widget.taskSubmissionModel.tsActualStartTime!,
                          _markers);
                      if (widget.taskSubmissionModel.tsActualEndTime != null)
                        addMarker(
                            'check-out',
                            LatLng(
                                double.parse(
                                    widget.taskSubmissionModel.tsEndLatitude!),
                                double.parse(widget
                                        .taskSubmissionModel.tsEndLongitude!) +
                                    (isSameLocation ? 0.00001 : 0)),
                            widget.taskSubmissionModel.tsActualEndTime!,
                            _markers);
                    },
                    markers: _markers.values.toSet(),
                  ),
                  // Text('مفاتح الخارطة'),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text('موقع البدء'.tr(args: [
                              // intl.DateFormat('H:mm').format(
                              //     DateTime.parse(widget.taskSubmissionModel.tsActualStartTime.toString()))
                            ])),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text('موقع الإنتهاء'.tr(args: [
                              // widget.taskSubmissionModel.tsActualEndTime != null
                              //     ? intl.DateFormat('H:mm').format(
                              //     DateTime.parse(widget.taskSubmissionModel.tsActualEndTime.toString()))
                              //     : ''
                            ])),
                          ],
                        ),
                        SizedBox(height: 14),
                      ],
                    ),
                  ),
                ],
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
          title: id == 'check-in'
              ? 'موقع البدء'
              : 'موقع الانتهاء',
          snippet: 'الوقت: ${intl.DateFormat('H:mm').format(DateTime.parse(time.toString()))}'.tr(args: [

          ])),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        id == 'check-in' ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
      ),
    );
    print('add marker');
    markersMap[id] = marker;
    setState(() {});
  }
}
