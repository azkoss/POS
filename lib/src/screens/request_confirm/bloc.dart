import 'package:bloc/bloc.dart';
import 'package:pos/src/db/payment_request_db.dart';
import 'package:pos/src/model/payment_request.dart';
import 'package:pos/src/services/payment_registration/repository.dart';
import 'package:wom_package/wom_package.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_event.dart';
import 'package:pos/src/screens/request_confirm/wom_creation_state.dart';
import 'package:meta/meta.dart';

class RequestConfirmBloc extends Bloc<WomCreationEvent, WomCreationState> {
  PaymentRegistrationRepository _repository;
  final PaymentRequest paymentRequest;

  PaymentRequestDb _requestDb;

  RequestConfirmBloc({@required this.paymentRequest}) {
    _repository = PaymentRegistrationRepository();
    _requestDb = PaymentRequestDb.get();
    dispatch(CreateWomRequest());
  }

  @override
  get initialState => WomCreationRequestEmpty();

  @override
  Stream<WomCreationState> mapEventToState(event) async* {
    if (event is CreateWomRequest) {
      yield WomCreationRequestLoading();

      final RequestVerificationResponse response =
          await _repository.generateNewPaymentRequest(paymentRequest);
      if (response.error != null) {
        print(response.error);
        insertRequestOnDb();
        yield WomCreationRequestError(error: response.error);
      } else {
        final bool verificationResponse =
            await _repository.verifyPaymentRequest(response);
        if (verificationResponse) {
          paymentRequest.deepLink =
              DeepLinkBuilder(response.otc, TransactionType.PAYMENT).build();
          paymentRequest.status = RequestStatus.COMPLETE;
          paymentRequest.registryUrl = response.registryUrl;
          await insertRequestOnDb();
          yield WomVerifyCreationRequestComplete(
            response: response,
          );
        } else {
          paymentRequest.status = RequestStatus.DRAFT;
          insertRequestOnDb();
          yield WomCreationRequestError(error: response.error);
        }
      }
    }
  }

  insertRequestOnDb() async {
    try {
      if (paymentRequest.id == null) {
        int id = await _requestDb.insertRequest(paymentRequest);
        print(id);
        paymentRequest.id = id;
        print(paymentRequest.id);
      } else {
        await _requestDb.updateRequest(paymentRequest);
      }
    } catch (ex) {
      print("insertRequestOnDb $ex");
    }
  }
}