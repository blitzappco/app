import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../components/loading.dart';
import '../components/modals/route_modal.dart';
import '../components/modals/route_preview_modal.dart';
import '../components/home_component.dart';
import '../maps/map_controller.dart';
import '../providers/account_provider.dart';
import '../providers/balance_provider.dart';
import '../providers/route_provider.dart';
import '../providers/tickets_provider.dart';
import '../providers/trips_provider.dart';
import '../utils/get_location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  double sheetPageHeight = 250;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController mapController;

  var geoLocator = Geolocator();
  late Position currentPosition;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final account = Provider.of<AccountProvider>(context, listen: false);

      final balance = Provider.of<BalanceProvider>(context, listen: false);

      final tickets = Provider.of<TicketsProvider>(context, listen: false);

      await balance.getBalance(account.token);
      await tickets.getTickets(account.token);
    });

    loadMapStyle();
  }

  late String customMapStyle;

  Future<void> loadMapStyle() async {
    customMapStyle = await rootBundle.loadString('assets/mapstyling.json');
  }

  void setupPositionLocator() async {
    final pos = await getCurrentLocation();

    CameraPosition cp = CameraPosition(
        target: LatLng(
          pos?.latitude ?? 0.0,
          pos?.longitude ?? 0.0,
        ),
        zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(builder: (context, auth, _) {
      return Consumer<TripsProvider>(builder: (context, trips, _) {
        return Consumer<RouteProvider>(builder: (context, route, _) {
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  polylines: route.polylinesSet,
                  padding: EdgeInsets.only(
                      bottom: route.mapPadding[route.page == 'home'
                          ? (trips.trips.length > 1 ? 1 : trips.trips.length)
                          : 0]),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;

                    // setCamera(
                    //     mapController, LatLng(route.from.lat, route.from.long));
                    setCameraLocation(mapController);
                  },
                  markers: <Marker>{
                    Marker(
                        markerId: const MarkerId('user_location'),
                        position: LatLng(route.position?.latitude ?? 0.0,
                            route.position?.longitude ?? 0.0),
                        icon: BitmapDescriptor.defaultMarker),
                    Marker(
                        markerId: const MarkerId('to'),
                        position: LatLng(route.to.lat, route.to.long),
                        icon: BitmapDescriptor.defaultMarker)
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(45.7579498, 21.2264023),
                    zoom: 13.0,
                  ),
                ),
                if (route.loading) const Loading(),
                if (route.page == 'home' && !route.loading)
                  const HomeComponent(),
                if (route.page == 'preview' && !route.loading)
                  RoutePreviewModal(
                    mapController: mapController,
                  ),
                if (route.page == 'route')
                  RouteModal(
                    mapController: mapController,
                  ),
              ],
            ),
          );
        });
      });
    });
  }
}
