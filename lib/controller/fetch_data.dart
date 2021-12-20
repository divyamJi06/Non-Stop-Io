import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tinderly/models/places.dart';

class GetPlaceData {
  List<Places> data=[] ;

Future<List<Places>> fetchUsers() async {
    Response response = await Dio().get('https://hiveword.com/papi/random/locationNames');
    if (response.statusCode == 200) {
      
        var getUsersData = response.data as List;
         data = getUsersData.map((i) => Places.fromJson(i)).toList();
        return data;
        } else {
            throw Exception("FAILd to load");
        }
    
    // return data;
}
}