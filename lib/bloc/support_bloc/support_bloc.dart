import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/message_model.dart';

part 'support_event.dart';
part 'support_state.dart';

// class SupportBloc extends Bloc<SupportEvent, SupportState> {
//   final SupportRepository repository;
//
//   SupportBloc(this.repository) : super(SupportInitial()) {
//     // Подписываемся на изменения состояния подключения
//     repository.connectionStatus.listen((isConnected) {
//       if (isConnected) {
//         print("WebSocket подключён");
//       } else {
//         print("WebSocket отключён");
//       }
//     });
//
//     on<ConnectSupport>((event, emit) {
//       repository.connect(event.userId);
//       add(FetchChatHistory());
//     });
//
//     on<SendMessage>((event, emit) {
//       repository.sendMessage(event.message);
//     });
//
//     on<FetchChatHistory>((event, emit) async {
//       emit(SupportLoading());
//       try {
//         await emit.forEach<List<Message>>(
//           repository.getChatHistory(),
//           onData: (messages) => SupportLoaded(messages),
//         );
//       } catch (e) {
//         emit(SupportError(e.toString()));
//       }
//     });
//   }
//
//   @override
//   Future<void> close() {
//     repository.close();
//     return super.close();
//   }
// }
