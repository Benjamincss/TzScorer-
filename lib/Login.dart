
import 'package:flutter/material.dart';
import 'sign.dart';
import 'Register.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final _unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.1, -0.9),
                child: InkWell(
                  onTap: () async {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(

                      width: 395,
                      height: 500,
                      decoration: BoxDecoration(
                        color: Color(0xFF2D2929),
                        borderRadius: BorderRadius.circular(50),
                        shape: BoxShape.rectangle,
                      ),
                      child: Image.network(
                        'https://zupimages.net/up/23/03/k5sh.png',
                        width: 0,
                        height: 69.8,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),

                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical:  8.0),
                child: Text(style: TextStyle(fontSize:30 ,    ),"Prêt à battre votre  "),
              )

                  , Text(style: TextStyle(fontSize:30   ),"Reccord ? ")
                  , Padding(
                    padding: const EdgeInsets.fromLTRB(85, 50, 50, 50),
                    child:
                    Center(   child: Text( style: TextStyle(fontSize:23 ,  ),"L'outil ultime dédié aux lanceurs sportifs")),
                  )

                ],
              )
              , Row( mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 197 ,
                    height: 65,
                    decoration:BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(55),
                          bottomRight: Radius.circular(55)
                      )
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Color(0xFFD0272B)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const sign()),
                        );

                      },
                      child: Text( style: TextStyle(fontSize: 22)  ,"Connexion"),
                    ),
                  )

                  ,
                  Container(
                    width: 197 ,
                    height: 65,
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular (45),
                            bottomRight: Radius.circular(32)
                        )
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Color(0xFF2D2929)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SingUpPage()),
                        );
                      },
                      child: Text(style: TextStyle(fontSize: 22),"Inscription"),
                    ),
                  )
                ])
            ],
          ),
        ),
      ),

    );
  }
}
