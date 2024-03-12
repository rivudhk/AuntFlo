import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class FirebaseDatabaseService {
  final userList = [];
  final _firestoreDb = FirebaseFirestore.instance;

  Future getuser() async {
    try {
      final CollectionReference _userCollectionReference =
      await _firestoreDb.collection('user');
      await _userCollectionReference.get().then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          userList.add(result.data());
        }
      });

      return userList;
    } on FirebaseException catch (e) {
      print('Error in firestore database');
    } catch (e) {
      print('Something went wrong');
    }
  }

  Future getsingleuser() async {
    try {
      final CollectionReference _userCollectionReference =
      _firestoreDb.collection('user');
      var user1Details = await _userCollectionReference.doc('user').get();
      if (user1Details.exists) {
        print('The user Details is ${user1Details.data()}');
      } else {
        print('user Details not found');
      }

      return userList;
    } on FirebaseException catch (e) {
      print('Error in firestore database');
    } catch (e) {
      print('Something went wrong');
    }
  }

  ///This function is used to create a user in Cloud Firebase
  void createUserInCloudFirebase({required UserModel userModel}) async {
    try {
      final CollectionReference _usersCollectionReference =
      await _firestoreDb.collection('users');

      await _usersCollectionReference.add(userModel.toJson()).whenComplete(() {
        print('User Created Success');
      });
    } catch (e) {
      print('Something went wrong $e');
    }
  }

  ///This function is used to get user details uId
  Future<UserModel?> getUserDetailsUsingUid({required String uId}) async {
    try {
      final CollectionReference _usersCollectionReference =
      _firestoreDb.collection('users');
      final snapShot =
      await _usersCollectionReference.where('id', isEqualTo: uId).get();
      final userModel = await snapShot.docs
          .map((doc) => UserModel.fromJson(
          doc as QueryDocumentSnapshot<Map<String, dynamic>>))
          .single;
      return userModel;
    } catch (e) {
      print('Something went wrong $e');
    }
    return null;
  }

  Future<List<UserModel>> getUsersFromDatabase() async {
    try {
      final CollectionReference _usersCollectionReference =
      _firestoreDb.collection('users');
      final documentSnapshot = await _usersCollectionReference.get();
      if (documentSnapshot.docs.isNotEmpty) {
        final userslist = documentSnapshot.docs
            .map((doc) => UserModel.fromJson(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>))
            .toList();
        return userslist;
      } else {
        return [];
      }
    } catch (e) {
      print('Something went wrong $e');
    }
    return [];
  }

  ///Function to update User using UID
  Future<UserModel?> updateUserUsingUID({required String uId, required UserModel userModel}) async{
    try{
      final CollectionReference _usersCollectionReference =
      _firestoreDb.collection('users');
      final snapShot =
      await _usersCollectionReference.where('id', isEqualTo: uId).get();
      if(snapShot.docs.isNotEmpty){
        final documentId = snapShot.docs.first.id;
        await _usersCollectionReference.doc(documentId).update(userModel.toJson());
        final userModelResponse = UserModel.fromJson(
            snapShot.docs.first as QueryDocumentSnapshot<Map<String, dynamic>>);
        return userModelResponse;
      }else{
        return null;
      }
    }catch(e){
      print('Something went wrong $e');
    }
    return null;
  }
}