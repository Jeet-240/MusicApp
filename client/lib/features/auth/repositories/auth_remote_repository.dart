import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ServerConstant.serverURL}/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 5));
      final responseBodyMap =
          jsonDecode(response.body) as Map<String, dynamic>; // Add timeout
      if (response.statusCode == 201) {
        // Success case
        return Right(UserModel.fromMap(responseBodyMap));
      } else {
        // Server error (400, 500, etc)
        return Left(AppFailure(responseBodyMap['detail']));
      }
    } on SocketException {
      // Server offline/unreachable
      throw Exception('Server is offline or unreachable');
    } on TimeoutException {
      throw Exception('Connection timeout - server may be offline');
    } catch (e) {
      // Generic error
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ServerConstant.serverURL}/auth/login'),
            body: jsonEncode({"email": email, "password": password}),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 5)); // Add timeout
      final responseBodyMap =
          jsonDecode(response.body) as Map<String, dynamic>; // Add timeout
      if (response.statusCode == 200) {
        // Success case
        return Right(
          UserModel.fromMap(
            responseBodyMap['user'],
          ).copyWith(token: responseBodyMap['token']),
        );
      } else {
        // Server error (400, 500, etc)
        return Left(AppFailure(responseBodyMap['detail']));
      }
    } on SocketException {
      // Server offline/unreachable
      throw Exception('Server is offline or unreachable');
    } on TimeoutException {
      throw Exception('Connection timeout - server may be offline');
    } catch (e) {
      // Generic error
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(
    String token
  ) async {
    try {
      final response = await http
          .get(
        Uri.parse('${ServerConstant.serverURL}/auth/'),
        headers: {'Content-Type': 'application/json' ,
          'x-auth-token': token,
        },
      )
          .timeout(Duration(seconds: 5)); // Add timeout
      final responseBodyMap =
      jsonDecode(response.body) as Map<String, dynamic>; // Add timeout
      if (response.statusCode == 200) {
        // Success case
        return Right(
          UserModel.fromMap(
            responseBodyMap,
          ).copyWith(token: token),
        );
      } else {
        // Server error (400, 500, etc)
        return Left(AppFailure(responseBodyMap['detail']));
      }
    } on SocketException {
      // Server offline/unreachable
      throw Exception('Server is offline or unreachable');
    } on TimeoutException {
      throw Exception('Connection timeout - server may be offline');
    } catch (e) {
      // Generic error
      return Left(AppFailure(e.toString()));
    }
  }
}
