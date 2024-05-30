import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class User{
  var id_;
  String firstName;
  String lastName;
  String email;
  DateTime dateB;
  User(this.id_, this.firstName,this.lastName, this.email,this.dateB);
}