import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:weather_application/api.dart';
import 'package:weather_application/weathermodal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchWidget(),
            const Gap(20),
            if(inProgress) CircularProgressIndicator() else Expanded(child: SingleChildScrollView(child: _buildWeatherWidget())),

          ],
        ),
      ),
    ));
  }

  Widget _buildSearchWidget(){
    return SearchBar(
      hintText: "Search Location",
      onSubmitted: (value) {
        _getWeatherData(value);
      },
    );
  }

  Widget _buildWeatherWidget(){
    if(response == null){
      return Text(message);
    }
    else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.location_on,size: 50,),
              Flexible(child: Text(response?.location?.name ?? "",style: const TextStyle(fontSize: 40,fontWeight: FontWeight.w300),),fit: FlexFit.loose,),
              Text(response?.location?.country ?? "",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
            ],
          ),
          Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text((response?.current?.tempC.toString() ?? "") + " °c",style: const TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),
              ),
              Text(response?.current?.condition?.text.toString() ?? "",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            ],
          ),
          Center(
            child: SizedBox(
                height: 200,
                child: Image.network("https:${response?.current?.condition?.icon}".replaceAll("64x64", "128x128"),scale: 0.7,)),
          ),
          Card(
            elevation: 4,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Humidity",response?.current?.humidity?.toString() ?? ""),
                    _dataAndTitleWidget("Wind Speed","${response?.current?.windKph?.toString() ?? ""} km/h"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("UV",response?.current?.uv?.toString() ?? ""),
                    _dataAndTitleWidget("Percipitation","${response?.current?.precipMm?.toString() ?? ""} mm"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dataAndTitleWidget("Local Time",response?.location?.localtime?.split(" ").last ?? ""),
                    _dataAndTitleWidget("Local Date",response?.location?.localtime?.split(" ").first ?? ""),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _dataAndTitleWidget(String title, String data){
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Text(data,
              style: const TextStyle(
              fontSize: 25,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(title,style: const TextStyle(
            fontSize: 25,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),),
        ],
      ),
    );
  }

  _getWeatherData(String location) async{

    setState(() {
      inProgress = true;
    });

    try{
      response = await WeatherApi().getCurrentWeather(location);
    }
    catch(e){
    message = "Failed to get Weather ";
    response = null;
    }
    finally{
      setState(() {
        inProgress = false;
      });
    }
  }
}
