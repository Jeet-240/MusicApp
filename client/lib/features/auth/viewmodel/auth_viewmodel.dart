import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_remote_repository.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel{
  late final AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build(){
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreference() async{
    await _authLocalRepository.init();
  }

  Future<void>signUpUser({
    required String name,
    required String email,
    required String password,
}) async {
    state = const AsyncLoading();
    final response =  await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    final val = switch (response){
      fp.Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      fp.Right(value: final r) => state = AsyncData(r),
    };

    print(val);

  }

  Future<void>loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final response =  await _authRemoteRepository.login(
      email: email,
      password: password,
    );
    final val = switch (response){
      fp.Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      fp.Right(value: final r) => state = _loginSuccess(r),
    };

    print(val);

  }


  AsyncValue<UserModel>? _loginSuccess(UserModel user){
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data((user));
  }

  Future<UserModel?>getData() async{
    state = const AsyncLoading();
    final token = _authLocalRepository.getToken();
    if(token != null){
      final res = await _authRemoteRepository.getCurrentUserData(token);
      final val = switch(res){
        fp.Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      fp.Right(value : final r) => state = _getDataSuccess(r),
      };

      return val.value;
    }

    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user){
    _currentUserNotifier.addUser(user);
    return state = AsyncData(user);
  }


}