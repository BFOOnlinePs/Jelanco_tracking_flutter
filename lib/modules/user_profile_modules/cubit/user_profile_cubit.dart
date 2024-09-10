import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/cubit/user_profile_states.dart';

class UserProfileCubit extends Cubit<UserProfileStates> {
  UserProfileCubit() : super(UserProfileInitialState());

  static UserProfileCubit get(context) => BlocProvider.of(context);


}