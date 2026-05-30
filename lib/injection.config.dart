// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'configs/modules/register_module.dart' as _i867;
import 'configs/network/http_api.dart' as _i827;
import 'configs/network/network.dart' as _i466;
import 'configs/network/network_info.dart' as _i700;
import 'configs/services/user_agent_service.dart' as _i618;
import 'core/global/nfc_notifier.dart' as _i220;
import 'core/global/settings_cubit.dart' as _i1062;
import 'core/global/user_provider.dart' as _i392;
import 'features/add_product_id/data/datasources/add_product_id_remote_date.dart'
    as _i307;
import 'features/add_product_id/data/repositories/add_product_id_repositoy_impl.dart'
    as _i979;
import 'features/add_product_id/domain/repositories/add_product_id_repository.dart'
    as _i805;
import 'features/add_product_id/domain/usecases/add_product_id_usecase.dart'
    as _i498;
import 'features/add_product_id/presentation/bloc/add_product_id_bloc.dart'
    as _i282;
import 'features/auth/data/datasources/auth_local_data.dart' as _i596;
import 'features/auth/data/datasources/auth_remote_data.dart' as _i919;
import 'features/auth/data/repositories/auth_repository_impl.dart' as _i111;
import 'features/auth/domain/repositories/auth_repository.dart' as _i1015;
import 'features/auth/domain/usecases/forget_password_usecase.dart' as _i300;
import 'features/auth/domain/usecases/sign_in_usecase.dart' as _i151;
import 'features/auth/domain/usecases/sign_up_usecase.dart' as _i261;
import 'features/auth/presentation/blocs/auth/auth_bloc.dart' as _i44;
import 'features/auth/presentation/blocs/signin/sign_in_bloc.dart' as _i621;
import 'features/feedback/data/datasources/feedback_remote_data.dart' as _i684;
import 'features/feedback/data/repositories/feedback_reposirory_impl.dart'
    as _i939;
import 'features/feedback/domain/repositories/feedback_repository.dart'
    as _i226;
import 'features/feedback/domain/usecases/post_feedback_usecase.dart' as _i454;
import 'features/feedback/presentation/blocs/feedback/feedback_bloc.dart'
    as _i510;
import 'features/home/data/datasources/home_remote_data.dart' as _i668;
import 'features/home/data/repositories/home_repository_impl.dart' as _i689;
import 'features/home/domain/repositories/home_repository.dart' as _i649;
import 'features/home/domain/usecases/chats/received_chats_usecase.dart'
    as _i324;
import 'features/home/domain/usecases/chats/sent_chats_usecase.dart' as _i156;
import 'features/home/domain/usecases/get_qr_codes_usecase.dart' as _i274;
import 'features/home/presentation/blocs/chats/chats_bloc.dart' as _i60;
import 'features/home/presentation/blocs/qr_codes/qr_codes_bloc.dart' as _i637;
import 'features/home/presentation/blocs/selected_view_index_cubit/selected_view_index_cubit.dart'
    as _i270;
import 'features/home/presentation/providers/gen_qrcodes_provider.dart'
    as _i136;
import 'features/home/presentation/providers/license_provider.dart' as _i918;
import 'features/home/presentation/providers/order_provider.dart' as _i221;
import 'features/home/presentation/providers/product_label_printer_provider.dart'
    as _i1029;
import 'features/home/presentation/providers/product_provider.dart' as _i480;
import 'features/home/presentation/providers/shipping_label_printer_provider.dart'
    as _i1005;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.factory<_i827.HttpApi>(() => _i827.HttpApi());
  gh.factory<_i700.NetworkInfo>(() => _i700.NetworkInfo());
  gh.factory<_i618.UserAgentService>(() => _i618.UserAgentService());
  gh.factory<_i220.NfcNotifier>(() => _i220.NfcNotifier());
  gh.factory<_i392.UserProvider>(() => _i392.UserProvider());
  gh.factory<_i136.GenQrcodesProvider>(() => _i136.GenQrcodesProvider());
  gh.factory<_i918.LicenseProvider>(() => _i918.LicenseProvider());
  gh.factory<_i221.OrderProvider>(() => _i221.OrderProvider());
  gh.factory<_i1029.ProductLabelPrinterProvider>(
    () => _i1029.ProductLabelPrinterProvider(),
  );
  gh.factory<_i480.ProductProvider>(() => _i480.ProductProvider());
  gh.factory<_i1005.ShippingLabelPrinterProvider>(
    () => _i1005.ShippingLabelPrinterProvider(),
  );
  gh.lazySingleton<_i1062.SettingsCubit>(
    () => _i1062.SettingsCubit(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i270.SelectedViewIndexCubit>(
    () => _i270.SelectedViewIndexCubit(gh<_i460.SharedPreferences>()),
  );
  gh.factory<_i919.AuthRemoteData>(
    () => _i919.AuthRemoteDataImpl(gh<_i827.HttpApi>()),
  );
  gh.factory<_i307.AddProductIdRemoteDate>(
    () => _i307.AddProductIdRemoteDateImpl(gh<_i827.HttpApi>()),
  );
  gh.factory<_i596.AuthLocalData>(
    () => _i596.AuthLocalDataImpl(gh<_i460.SharedPreferences>()),
  );
  gh.factory<_i1015.AuthRepository>(
    () => _i111.AuthRepositorImpl(
      gh<_i919.AuthRemoteData>(),
      gh<_i466.NetworkInfo>(),
      gh<_i596.AuthLocalData>(),
    ),
  );
  gh.factory<_i805.AddProductIdRepository>(
    () => _i979.AddProductIdRepositoryImpl(
      gh<_i700.NetworkInfo>(),
      gh<_i307.AddProductIdRemoteDate>(),
    ),
  );
  gh.factory<_i668.HomeRemoteData>(
    () => _i668.HomeRemoteDataImpl(gh<_i466.HttpApi>()),
  );
  gh.factory<_i684.FeedbackRemoteData>(
    () => _i684.FeedbackRemoteDataImpl(gh<_i466.HttpApi>()),
  );
  gh.factory<_i498.AddProductIdUsecase>(
    () => _i498.AddProductIdUsecase(gh<_i805.AddProductIdRepository>()),
  );
  gh.lazySingleton<_i282.AddProductIdBloc>(
    () => _i282.AddProductIdBloc(gh<_i498.AddProductIdUsecase>()),
  );
  gh.factory<_i300.ForgetPasswordUsecase>(
    () => _i300.ForgetPasswordUsecase(gh<_i1015.AuthRepository>()),
  );
  gh.factory<_i151.SignInUsecase>(
    () => _i151.SignInUsecase(gh<_i1015.AuthRepository>()),
  );
  gh.factory<_i261.SignupUsecase>(
    () => _i261.SignupUsecase(gh<_i1015.AuthRepository>()),
  );
  gh.factory<_i649.HomeRepository>(
    () => _i689.HomeRepositoryImpl(
      gh<_i466.NetworkInfo>(),
      gh<_i668.HomeRemoteData>(),
    ),
  );
  gh.factory<_i226.FeedbackRepository>(
    () => _i939.FeedbackRepositoryImpl(
      gh<_i684.FeedbackRemoteData>(),
      gh<_i466.NetworkInfo>(),
      gh<_i618.UserAgentService>(),
    ),
  );
  gh.lazySingleton<_i44.AuthBloc>(
    () => _i44.AuthBloc(
      gh<_i261.SignupUsecase>(),
      gh<_i300.ForgetPasswordUsecase>(),
    ),
  );
  gh.lazySingleton<_i621.SignInBloc>(
    () => _i621.SignInBloc(gh<_i151.SignInUsecase>()),
  );
  gh.factory<_i324.ReceivedChatsUsecase>(
    () => _i324.ReceivedChatsUsecase(gh<_i649.HomeRepository>()),
  );
  gh.factory<_i156.SentChatsUsecase>(
    () => _i156.SentChatsUsecase(gh<_i649.HomeRepository>()),
  );
  gh.factory<_i274.GetQrCodesUsecase>(
    () => _i274.GetQrCodesUsecase(gh<_i649.HomeRepository>()),
  );
  gh.factory<_i454.PostFeedbackUsecase>(
    () => _i454.PostFeedbackUsecase(gh<_i226.FeedbackRepository>()),
  );
  gh.lazySingleton<_i510.FeedbackBloc>(
    () => _i510.FeedbackBloc(gh<_i454.PostFeedbackUsecase>()),
  );
  gh.lazySingleton<_i637.QrCodesBloc>(
    () => _i637.QrCodesBloc(gh<_i274.GetQrCodesUsecase>()),
  );
  gh.lazySingleton<_i60.ChatsBloc>(
    () => _i60.ChatsBloc(
      gh<_i156.SentChatsUsecase>(),
      gh<_i324.ReceivedChatsUsecase>(),
    ),
  );
  return getIt;
}

class _$RegisterModule extends _i867.RegisterModule {}
