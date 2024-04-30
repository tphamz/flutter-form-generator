// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sample/models/element_model.dart';
import 'dart:convert';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:sample/components/elements/form_element.dart';
import 'package:sample/providers/record_provider.dart';

class LocationElement extends FormElement {
  final Location location = Location();
  LocationElement({super.key, required super.element});

  @override
  LocationElementState createState() => LocationElementState();
}

class LocationElementState extends FormElementState<LocationElement> {
  bool onloading = false;
  @override
  dynamic toJsValue(dynamic elementValue) {
    return {
      "latitude": elementValue.latitude ?? 0,
      "longitude": elementValue.longitude ?? 0,
      "accuracy": elementValue.accuracy ?? 0,
      "altitude": elementValue.altitude ?? 0,
      "speed": elementValue.speed ?? 0,
      "speedAccuracy": elementValue.speedAccuracy ?? 0,
      "time": elementValue.time
    };
  }

  @override
  dynamic toElementValue(String jsValue) {
    try {
      dynamic data = jsonDecode(jsValue);
      return LocationData.fromMap(data);
    } catch (err) {
      print(err);
      return null;
    }
  }

  final ThemeData base = ThemeData();

  Future<void> handleTakingLocation() async {
    onloading = true;
    setState(() {});
    bool serviceEnabled = await widget.location.serviceEnabled();
    if (!serviceEnabled)
      serviceEnabled = await widget.location.requestService();
    if (!serviceEnabled) {
      setElementError("Location is not enabled");
      return setState(() {
        onloading = false;
      });
    }
    PermissionStatus permissionGranted = await widget.location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await widget.location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setElementError("Location permission is denied");
        return setState(() {
          onloading = false;
        });
      }
    }
    setElementError(null);
    onloading = false;
    LocationData locationData = await widget.location.getLocation();
    print("locationData::$locationData");

    return onChanged(locationData);
  }

  void setElementError(String? message) {
    widget.element.hasError = (message != "" && message != null);
    widget.element.validationMessage = message ?? "";
  }

  Widget _skeletonView() => const SkeletonLine(
      style: SkeletonLineStyle(width: double.infinity, height: 200));

  Widget _errorView() => Center(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.error)),
          height: 200,
          width: double.infinity,
          child: Center(
              child: Text(
            widget.element.validationMessage,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ))));

  Widget _mapView(dynamic record) => SizedBox(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
          options: MapOptions(
            center: LatLng(record.latitude, record.longitude),
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(record.latitude, record.longitude),
                  width: 64,
                  height: 64,
                  builder: (context) =>
                      Image.asset("assets/icon/location_marker.png"),
                ),
              ],
            ),
          ]));

  Widget showView(record) {
    if (onloading) return _skeletonView();
    if (widget.element.hasError) return _errorView();
    if (record == null) return Container();
    return _mapView(record);
  }

  @override
  Widget render(BuildContext context, RecordProvider recordState) {
    dynamic record = recordState.record[widget.element.name];
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Text(
              '${widget.element.label}${widget.element.is_required == true ? "*" : ""}',
              style: const TextStyle(fontSize: 14),
              textDirection: TextDirection.ltr)),
      Material(
          child: Container(
              constraints: const BoxConstraints(
                  minHeight: 50, minWidth: double.infinity),
              decoration: BoxDecoration(
                  border: Border.all(color: base.focusColor),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0) //
                      )),
              child: InkWell(
                onTap: onloading ? () {} : handleTakingLocation,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(children: [
                          const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.location_pin, size: 24.0)),
                          Text(record == null
                              ? "Confirm Location"
                              : "Refresh Location")
                        ]))),
              ))),
      showView(record),
      LocationDataWidget(record: record, element: widget.element)
    ]);
  }
}

class LocationDataWidget extends StatefulWidget {
  final LocationData? record;
  final ElementModel? element;
  const LocationDataWidget({super.key, this.element, this.record});

  @override
  LocationDataWidgetState createState() => LocationDataWidgetState();
}

class LocationDataWidgetState extends State<LocationDataWidget> {
  bool isExpanded = false;
  @override
  Widget build(context) {
    if (widget.record != null && !(widget.element?.hasError ?? false))
      return ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              this.isExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) =>
                    const ListTile(
                      title: Text("Location Data"),
                    ),
                body: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "latitude: ${widget.record?.latitude ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "longitude: ${widget.record?.longitude ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "accuracy: ${widget.record?.accuracy ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "altitude: ${widget.record?.altitude ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("speed: ${widget.record?.speed ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "speedAccuracy: ${widget.record?.speedAccuracy ?? 0}")),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("time: ${widget.record?.time ?? 0}"))
                    ])),
                isExpanded: isExpanded),
          ]);
    return Container();
  }
}
