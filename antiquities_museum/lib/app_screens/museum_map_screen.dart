import 'dart:async';
import 'dart:math';
import 'package:antiquities_museum/app_screens/antique_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:antiquities_museum/app_screens/search_screen.dart';

class MuseumMap extends StatefulWidget {
  const MuseumMap({Key? key}) : super(key: key);

  @override
  _MuseumMapState createState() => _MuseumMapState();
}

class _MuseumMapState extends State<MuseumMap> {
  // Define Museum Area variables to manage the geographic area displayed.
  double _minLat = 0;
  double _maxLat = 0;
  double _minLng = 0;
  double _maxLng = 0;

  // Define the dimensions of the map displayed.
  final double _mapWidth = 600.0;
  final double _mapHeight = 900.0;

  // Variable for managing overlays, like popups or tooltips.
  OverlayEntry? _overlayEntry;

  // Variables to store the user's current position on the map.
  double _userX = 0.0;
  double _userY = 0.0;

  // Subscription to location updates.
  StreamSubscription<Position>? _positionStreamSubscription;

  // Variables to keep track of the last known position
  double? _lastKnownLatitude;
  double? _lastKnownLongitude;

  // Variables to keep track zooming
  final PhotoViewController zoomController = PhotoViewController();
  double currentScale = 1.0;

  // Variables to keep track Compass
  double? _heading = 0;
  late StreamSubscription<CompassEvent> _compassSubscription;  // Subscription object

  // Variables to keep track Antiques Data
  var antiquesData = [];
  bool isPros = true;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions(); // Check and request location permissions on initialization.

    zoomController.outputStateStream.listen((PhotoViewControllerValue value) {
      // Check the scale whenever it changes
      if (value.scale != null) {
        setState(() {
          currentScale = value.scale!;
        });
      }
    });

    _compassSubscription = FlutterCompass.events!.listen((compassEvent) {
      setState(() {
        _heading = compassEvent.heading; // Update heading on new compass event
      });
    });

    fetchAndSortAntiquesWithMapLoc();

  }

  // Function to fetch Antiques documents
  Future<void> fetchAndSortAntiquesWithMapLoc() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Perform the query to get documents with 'map_loc' field
      QuerySnapshot querySnapshot = await firestore
          .collection('Antiques')
          .where('map_loc', isNotEqualTo: null)  // Ensures the field exists and is not null
          .get();

      // Clear existing data
      antiquesData.clear();

      // Convert the query snapshot to a list of maps
      List<Map<String, dynamic>> tempData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) => data.containsKey('map_loc') && data['map_loc'] is int)  // Ensure 'map_loc' is an integer
          .toList();

      // Sort the list based on the 'map_loc' field
      tempData.sort((a, b) => (a['map_loc'] as int).compareTo(b['map_loc'] as int));

      // Assign sorted data to global list
      setState(() {
        antiquesData = tempData;
        isPros = false;
      });

    } catch (e) {
      print('Error fetching or sorting antiques with map_loc: $e');
    }
  }

  // Method to check and request location permissions.
  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.location.status; // Check the current permission status.
    if (!status.isGranted) { // If not granted, request permission.
      await Permission.location.request();
    }
    if (await Permission.location.isGranted) { // If permission is granted, proceed to get location.
      _getCurrentLocation();
      _startLocationUpdates();
    } else {
      openAppSettings(); // If denied, open app settings to let the user change permission settings.
    }
  }

  // Method to get the current location of the user.
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      _setMuseumArea(position.latitude, position.longitude); // Set Museum Area based on current location.
      _updateUserPosition(position.latitude, position.longitude); // Update the user's position on the map.
    } catch (e) {
      print('Failed to get current location: $e');
    }
  }

  // Method to start listening to location updates.
  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Minimum change in distance (meters) before updates are sent
      ),
    ).listen((Position position) {
      _updateUserPosition(position.latitude, position.longitude);
      print("New latitude: ${position.latitude}");
      print("New longitude: ${position.longitude}");
      print("===" * 10);
    });
  }

  void _setMuseumArea(double lat, double lng) {
    const double distanceNorth = 200.0; // Distance north in meters the Museum Area extend

    // Convert the north distance from meters to degrees latitude
    double latDeltaNorth = distanceNorth / 111320.0; // meters to degrees

    // Set the user at the southern edge of the box and extend it northward by the specified distance
    _minLat = lat; // User's current latitude is the southern edge
    _maxLat = lat + latDeltaNorth; // Extend north by 200 meters converted to degrees of latitude

    // Assuming the Museum Area extends 50 meters east and west of the user's current longitude
    const double distanceEastWest = 50.0; // Distance the Museum Area extend east and west
    double lngDelta = distanceEastWest / (111320.0 * cos(lat * (pi / 180.0))); // Convert meters to degrees

    _minLng = lng - lngDelta; // Extend west
    _maxLng = lng + lngDelta; // Extend east

    print("Museum minLat: $_minLat");
    print("Museum maxLat: $_maxLat");
    print("Museum minLng: $_minLng");
    print("Museum maxLng: $_maxLng");
  }

  void _updateUserPosition(double lat, double lng) {
    // Convert GPS coordinates to image coordinates
    double x = _mapWidth * (lng - _minLng) / (_maxLng - _minLng);
    double y = _mapHeight * (1 - (lat - _minLat) / (_maxLat - _minLat)); // Invert y-axis

    // Ensure the position is within the map boundaries
    setState(() {
      _userX = x.clamp(0.0, _mapWidth  - 48.0 )  - 50;// 48 is the width of the pin
      _userY = y.clamp(0.0, _mapHeight - 48.0) - 100; // 48 is the height of the pin
    });
  }

  // Shows an overlay with details about an item
  void _showOverlay(BuildContext context, Offset position, String title, String description, String image, antiqueData) {
    _removeOverlay();
    _overlayEntry = createOverlayEntry(context, position, title, description, image, antiqueData);
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  // Removes any active overlay from the screen
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    // Ensures the stream is cancelled when the state is disposed
    _positionStreamSubscription?.cancel();
    _removeOverlay();
    zoomController.dispose();
    _compassSubscription.cancel();
    super.dispose();
  }

  OverlayEntry createOverlayEntry(BuildContext context, Offset position, String title, String description, String image, antiqueData) {
    double overlayWidth = 250;
    double overlayHeight = 360;

    double left = position.dx;
    double top = position.dy;
    var _screenSize = MediaQuery.of(context).size;  // Get screen size

    // Adjust position to prevent overflow
    if (position.dx + overlayWidth > _screenSize.width) {
      left = _screenSize.width - overlayWidth;
    }
    if (position.dy + overlayHeight > _screenSize.height) {
      top = _screenSize.height - overlayHeight;
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: top,
        child: Material(
          borderRadius: BorderRadius.circular(25),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 8.0,
          child: Container(
            constraints: BoxConstraints(
              minHeight: overlayHeight,
              minWidth: overlayWidth,
            ),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  width: 220,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 15,),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(35)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          child:Image.network(
                            image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for image errors
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: const Color(0xFF131A5C),
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10,),
                      Text(description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: appData.lang == 'ar' ? TextAlign.right : TextAlign.left,
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed:(){
                          _removeOverlay();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AntiqueScreen(antiqueData: antiqueData),
                            ),
                          );
                          },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          ),
                          padding: MaterialStateProperty.all(EdgeInsets.zero), // Override padding for custom alignment
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3D77BB), Color(0xFF98BDE9)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Container(
                            width: 220,
                            constraints: const BoxConstraints(minWidth: 88, minHeight: 36), // Minimum touch target size per Material guidelines
                            alignment: Alignment.center,
                            child: Text(
                                appData.lang == 'ar'? 'المزيد من التفاصيل' : appData.lang == 'es'? 'Ver más' : appData.lang == 'de'? 'Mehr sehen' : 'see more',
                              style: const TextStyle(fontFamily: 'Serif',fontSize: 17),),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                Positioned(
                  right: -10,
                  top: -10,
                  child:IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(Icons.close),
                    onPressed: () => _removeOverlay(),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: _removeOverlay,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: AppBar(
              backgroundColor: const Color(0xffF1F8FD),
              elevation: 0,
              title: Text(
                appData.lang == 'ar'? 'خريطة المتحف' : appData.lang == 'es'? 'Mapa' : appData.lang == 'de'? 'Karte' : "Museum Map",
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Serif',
                  color: Colors.black,
                  shadows: [Shadow(offset: Offset(1.5, 1.5), blurRadius: 3.0, color: Colors.black26)],
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      _removeOverlay();
                      showSearch(context: context, delegate: SearchScreen());
                    },
                    icon: const Icon(Icons.search),
                  ),
                )
              ],
            ),
          ),
        ),
        body: PhotoView.customChild(
          childSize: Size(_mapWidth, _mapHeight),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 3,
          backgroundDecoration: const BoxDecoration(color: Colors.white),
          enableRotation: false,
          controller: zoomController,

          child: Stack(
            children: <Widget>[
              Image.asset('assets/images/museum_map.jpg', width: _mapWidth, height: _mapHeight),
              if(_userX != 0 && _userY != 0 )
              Positioned(
                left: _userX,
                top: _userY,
                child: Transform.rotate(
                    angle: ((_heading ?? 0) * (pi / 180) * -1),
                    child: const Icon(Icons.navigation, color: Colors.blueAccent, size: 40.0)),
              ),

              if (currentScale >= 0.7)
                Positioned(
                left: 80,
                top: 210,
                child: placeView(
                    text: appData.lang == 'ar'? "تحف من موقع الإسكندرية" :
                          appData.lang == 'es'? "Antigüedades del Sitio BA" :
                          appData.lang == 'de'? "Antiquitäten der Bibliotheca Alexandrina" :
                          'Antiques of BA site',
                ),
              ), // Antiques of BA site

              if (currentScale >= 0.7)
                Positioned(
                  left: 70,
                  top: 490,
                  child: placeView(
                      text: appData.lang == 'ar'? "الحياة بعد الموت" :
                            appData.lang == 'es'? "La Vida Más Allá" :
                            appData.lang == 'de'? "Das Leben nach dem Tod" :
                            'in the After Life',
                  ),
                ), // in the After Life

              if (currentScale >= 0.8)
                Positioned(
                  left: 200,
                  top: 120,
                  child: placeView(
                      text: appData.lang == 'ar'? "تحف العصر اليوناني الروماني" :
                            appData.lang == 'es'? "Antigüedades Greco-Romanas" :
                            appData.lang == 'de'? "Griechisch-römische Antiquitäten" :
                            'Greco Roman Antiques'
                      , width: 120.0),
                ), // Greco Roman Antiques

                Positioned(
                  left: 225,
                  bottom: 35,
                  child: placeView(
                      text: appData.lang == 'ar'? "المدخل" :
                            appData.lang == 'es'? "Entrada" :
                            appData.lang == 'de'? "Eingang" :
                            'Entrance',
                      width: 120.0,icon: Icons.assignment_return ),
                ), // Entrance

              if (currentScale >= 0.9)
                Positioned(
                  left: 325,
                  top: 520,
                  child: placeView(
                      text: appData.lang == 'ar'? "مقتنيات جزيرة نيلسون" :
                            appData.lang == 'es'? "Colección de la Isla Nelson" :
                            appData.lang == 'de'? "Sammlung von Nelson Island" :
                            'Nelson island collection',
                      width: 120.0),
                ), // Nelson island collection

              if (currentScale >= 0.9)
                Positioned(
                  left: 335,
                  bottom: 100,
                  child: placeView(
                      text: appData.lang == 'ar'? "مساحة اضافيه" :
                            appData.lang == 'es'? "Extensión" :
                            appData.lang == 'de'? "Erweiterung" :
                            'Extension',
                      width: 120.0),
                ), // Extension

              if (currentScale >= 0.8)
                Positioned(
                  right: 40,
                  top: 80,
                  child: placeView(
                    text: appData.lang == 'ar'? "تحف بيزنطية" :
                          appData.lang == 'es'? "Antigüedad Bizantina" :
                          appData.lang == 'de'? "Byzantinisches Antiquität" :
                          'Byzantine Antique',
                  ),
                ), // Byzantine Antique


              if (currentScale >= 0.8)
                Positioned(
                  right: 40,
                  top: 400,
                  child: placeView(
                    text: appData.lang == 'ar'? "تحف إسلامية" :
                    appData.lang == 'es'? "Antigüedades Islámicas" :
                    appData.lang == 'de'? "Islamische Antiquitäten" :
                    'Islamic Antiques',
                  ),
                ), // Islamic Antiques



              if (!isPros) ...[
              // left antiques
              buildAntiquePin(context, 142.5, 60, antiquesData[0]),
              buildAntiquePin(context, 142.5, 203, antiquesData[1]),
              buildAntiquePin(context, 142.5, 350, antiquesData[2]),
              buildAntiquePin(context, 142.5, 635, antiquesData[3]),

              // centre antiques
              buildAntiquePin(context, 267, 60, antiquesData[4]),
              buildAntiquePin(context, 267, 203, antiquesData[5]),
              buildAntiquePin(context, 267, 350, antiquesData[6]),
              buildAntiquePin(context, 267, 495, antiquesData[7]),
              buildAntiquePin(context, 267, 635, antiquesData[8]),

              // right antiques
              buildAntiquePin(context, 400, 60, antiquesData[9]),
              buildAntiquePin(context, 400, 203, antiquesData[10]),
              buildAntiquePin(context, 400, 350, antiquesData[11]),
              ],

            ],
          ),
        ),
      ),
    );
  }

  Widget buildAntiquePin(BuildContext context, double left, double top, Map antiqueData) {

    var title = '';
    var description = '';
    var image = antiqueData['images'][0];

    if(appData.lang == 'en'){
      title = antiqueData['name_en'];
      description = antiqueData['description_en'];
    }
    else if(appData.lang == 'ar'){
      title = antiqueData['name_ar'];
      description = antiqueData['description_ar'];
    }
    else if(appData.lang == 'es'){
      title = antiqueData['name_es'];
      description = antiqueData['description_es'];
    }
    else if(appData.lang == 'de'){
      title = antiqueData['name_de'];
      description = antiqueData['description_de'];
    }

    return
      Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          Offset position = Offset(left, top); // Adjust as needed to position the overlay correctly
          _showOverlay(context, details.globalPosition, title, description, image, antiqueData);
        },
        child:
        currentScale >= 1.1 ?
            Container(
              margin: EdgeInsets.only(top: 15,left: 20),
              width: 65,
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      border: Border.all(color: Colors.grey, ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child:Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for image errors
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            padding: EdgeInsets.all(20),
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              strokeAlign: .5,
                              color: const Color(0xFF131A5C),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                      ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ):
        currentScale >= .5 ?
            Container(
          width: 35,
          height: 35,
          margin: const EdgeInsets.all(35),
          decoration:BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: Icon(Icons.stadium_outlined),
        ):
        Container(),
      ),
    );
  }

  Widget placeView({required text, width = 80.0, icon = Icons.push_pin}){
    return Container(
      width: width,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.5,color: Colors.grey)
              ),
              child: Transform.rotate(
                  angle: icon == Icons.push_pin ?  35 * pi / 180 : 0, // Converting 45 degrees to radians
                  child: Icon(icon, size: 25.0)
              )
          ),
          const SizedBox(height: 8),
          cusText(text: text),
        ],
      ),
    );
  }

  Widget cusText({required text }){
    return Text(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      style: const TextStyle(
        fontSize: 16,
        fontFamily: 'Serif',
        color: Colors.black,
        shadows: [
          Shadow(
            offset: Offset(1.5, 1.5),
            blurRadius: 3.0,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}
