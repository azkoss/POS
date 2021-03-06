import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos/src/blocs/home/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PosSelectionPage extends StatefulWidget {
  static const String routeName = '/pos_selection';
  @override
  _PosSelectionPageState createState() => _PosSelectionPageState();
}

class _PosSelectionPageState extends State<PosSelectionPage> {
  HomeBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleziona il POS da gestire'),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          for (int i = 0; i < bloc.merchants.length; i++)
            SliverStickyHeaderBuilder(
              builder: (context, state) => Container(
//                padding: EdgeInsets.all(4.0),
                color: (state.isPinned ? Colors.blue : Colors.blue[200])
                    .withOpacity(1.0 - state.scrollPercentage),
                /*  child: ListTile(
                  leading: CircleAvatar(
                    child: Text('M'),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        bloc.merchants[i].name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        bloc.merchants[i].address,
                      ),
                      Text(
                        '${bloc.merchants[i].zipCode} - ${bloc.merchants[i].city}',
                      ),
                      Text(bloc.merchants[i].fiscalCode),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),*/
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      bloc.merchants[i].name,
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(Icons.info),
                        color: Colors.white,
                        onPressed: () {
                          Alert(
                            context: context,
                            style: AlertStyle(isCloseButton: false),
                            title: bloc.merchants[i].name,
                            content: Column(
                              children: <Widget>[
                                Text(
                                  bloc.merchants[i].address,
                                ),
                                Text(
                                  '${bloc.merchants[i].zipCode} - ${bloc.merchants[i].city}',
                                ),
                                Text(bloc.merchants[i].fiscalCode),
                                const SizedBox(
                                  height: 4,
                                ),
                              ],
                            ),
                          ).show();
                        }),
                  ],
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(
                    leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: Icon(MdiIcons.storeOutline)),
                    trailing: Icon(Icons.arrow_right),
                    title: Text(bloc.merchants[i].posList[index].name),
                    onTap: () {
                      context.bloc<HomeBloc>().setMerchantAndPosId(
                          bloc.merchants[i].id,
                          bloc.merchants[i].posList[index].id);
                      Navigator.of(context).pop();
                    },
                  ),
                  childCount: bloc.merchants[i].posList.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
