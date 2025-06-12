import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_local_repository.g.dart';
@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref){
  return AuthLocalRepository();
}
class AuthLocalRepository {



  late SharedPreferences _sharedPreferences;

  Future<void> init() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if(token!=null){
       _sharedPreferences.setString('x-auth-token', token);
    }else{
      _sharedPreferences.remove('x-auth-token');
    }
  }

  String? getToken(){
    final token =  _sharedPreferences.getString('x-auth-token');
    return token;
  }
}