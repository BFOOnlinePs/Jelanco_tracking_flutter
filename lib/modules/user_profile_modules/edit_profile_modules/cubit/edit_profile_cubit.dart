import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jelanco_tracking_system/modules/user_profile_modules/edit_profile_modules/cubit/edit_profile_states.dart';

class EditProfileCubit extends Cubit<EditProfileStates> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context) => BlocProvider.of(context);


}