import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/models/failure.dart';

part 'generic_state.dart';

class GenericCubit<T> extends Cubit<GenericCubitState<T>> {
  GenericCubit(T data) : super(GenericInitialState<T>(data));
  onLoadingState() {
    emit(GenericLoadingState<T>(data: state.data, changed: !state.changed));
  }
  onDismissLoadingState() {
    emit(GenericDismissLoadingState<T>(
        data: state.data, changed: !state.changed));
  }
  onUpdateData(T data) {
    emit(GenericUpdatedState<T>(data, !state.changed));
  }
  onChangeState() {
    emit(GenericChangeState<T>(data: state.data, changed: !state.changed));
  }
  onErrorState(Failure responseError) {
    emit(GenericErrorState<T>(
        responseError: responseError,
        changed: !state.changed,
        data: state.data));
  }
}
