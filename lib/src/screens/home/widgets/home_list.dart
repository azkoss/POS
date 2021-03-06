import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pos/localization/app_localizations.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:pos/src/blocs/payment_request/payment_request_bloc.dart';
import 'package:pos/src/model/payment_request.dart';

import 'package:pos/src/screens/create_payment/create_payment.dart';
import 'package:pos/src/screens/home/widgets/card_request.dart';
import 'package:pos/src/screens/request_confirm/request_confirm.dart';
import 'package:pos/src/screens/request_datails/request_datails.dart';
import 'package:wom_package/wom_package.dart';
import 'package:share/share.dart';

class HomeList extends StatefulWidget {
  final List<PaymentRequest> requests;

  HomeList({Key key, this.requests}) : super(key: key);

  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<HomeBloc>(context);
    return ListView.builder(
        itemCount: widget.requests.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: widget.requests[index].status == RequestStatus.COMPLETE
                ? () => goToDetails(index)
                : null,
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: CardRequest2(
                request: widget.requests[index],
                onDelete: () => onDelete(index),
                onEdit: () => onEdit(index),
                onDuplicate: () => onDuplicate(index),
              ),
              actions: <Widget>[
                MySlideAction(
                  icon: Icons.share,
                  color: Colors.green,
                  onTap: () {
                    Share.share('${widget.requests[index].deepLink}');
                  },
                ),
                if (widget.requests[index].status == RequestStatus.COMPLETE)
                  if (widget.requests[index].persistent)
                    MySlideAction(
                      icon: Icons.refresh,
                      color: Colors.yellow,
                      onTap: () => onDuplicate(index),
                    ),
                if (widget.requests[index].status != RequestStatus.COMPLETE)
                  MySlideAction(
                    icon: Icons.edit,
                    color: Colors.orange,
                    onTap: () => onEdit(index),
                  ),
              ],
              secondaryActions: <Widget>[
                /*MySlideAction(
                  icon: Icons.archive,
                  color: Colors.yellow,
                  onTap: () => _showSnackBar(context, 'Archive'),
                ),*/
                MySlideAction(
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () => onDelete(index),
                ),
              ],
            ),
          );
        });
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  goToDetails(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestDetails(
          paymentRequest: widget.requests[index],
        ),
      ),
    );
  }

  onDuplicate(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestConfirmScreen(
          paymentRequest: widget.requests[index].copyFrom(),
        ),
      ),
    );
  }

  onEdit(int index) {
    final provider = BlocProvider(
      child: GenerateWomScreen(),
      create: (ctx) => CreatePaymentRequestBloc(
          posId: bloc.selectedPosId,
          draftRequest: widget.requests[index],
          languageCode: AppLocalizations.of(context).locale.languageCode),
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => provider));
  }

  onDelete(int index) async {
    debugPrint("onDelete");
    final result = await bloc.deleteRequest(widget.requests[index].id);
    debugPrint("onDelete from DB complete: $result");
    if (result > 0) {
      setState(() {
        widget.requests.removeAt(index);
      });
    }
  }
}

class MySlideAction extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color color;
  final String caption;

  const MySlideAction(
      {Key key, this.onTap, this.icon, this.color, this.caption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
//      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.transparent,
      child: Center(
        child: Card(
          color: color,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IconSlideAction(
            caption: caption,
            color: Colors.transparent,
            foregroundColor: Colors.white,
            icon: icon,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
