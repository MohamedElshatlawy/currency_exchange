import '../../../../core/blocs/generic_cubit/generic_cubit.dart';

class HomeViewModel {
  HomeViewModel();

  GenericCubit<int> currentIndex = GenericCubit(0);

  updateCurrentIndex(int index) {
    currentIndex.onLoadingState();
    currentIndex.onUpdateData(index);
  }
}
