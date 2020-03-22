import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GameBackground(),
  ));
}

class GameBackground extends StatefulWidget {
  @override
  _GameBackgroundState createState() => _GameBackgroundState();
}

class _GameBackgroundState extends State<GameBackground>
    with TickerProviderStateMixin {
  int counter = 0;
  AnimationController birdController;
  Animation birdMouvement;
  Tween animation;
  double x = 0.5;
  AnimationController obstacleController;
  Animation obstacleMouvement;
  Tween animation2;
  @override
  void initState() {
    super.initState();
    birdController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = new Tween(begin: 1.0, end: -1.0);
    birdMouvement =
        CurvedAnimation(curve: Curves.linear, parent: birdController);
    birdMouvement.addStatusListener(listener);
    birdMouvement.addListener(mouvement);

    obstacleController = new AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    obstacleMouvement =
        CurvedAnimation(curve: Curves.linear, parent: obstacleController);
    animation2 = new Tween(begin: 1.0, end: -1.0);
    obstacleMouvement.addListener(() {
      double positionObstacle = getPositionOfObsatcle();
      double positionBird = getPostitionOfBird();
      if ((positionObstacle < -0.15 && positionObstacle > -0.25) &&
          (positionBird > 0.5 || positionBird < 0.05)) {
        obstacleController.reset();
        obstacleController.repeat();
        setState(() {
          counter = 0;
        });
      }
    });
    obstacleController.repeat();
  }

  void listener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      birdController.animateTo(0.0,
          curve: Curves.easeIn,
          duration: Duration(
              milliseconds:
                  (((-getPostitionOfBird() + 1) / 2) * 1500).toInt()));
    }
  }

  double getPostitionOfBird() {
    return animation.evaluate(this.birdMouvement);
  }

  double getPositionOfObsatcle() {
    return animation2.evaluate(this.obstacleMouvement);
  }

  void mouvement() {
    x = (-getPostitionOfBird() + 1.0) / 2;
  }

  Widget builderBird(BuildContext context, Widget child) {
    return Align(
      alignment: Alignment(-0.2, getPostitionOfBird()),
      child: Container(
        height: 50,
        width: 50,
        child: SvgPicture.asset("assets/images/bird.svg")
        ,
      ),
    );
  }

  Widget builderObstacle(BuildContext context, Widget child) {
    double height = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment(getPositionOfObsatcle(), 1.0),
      child: Container(
        height: height,
        width: 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: height * 0.5,
              width: 30,
              color: Color(0xff10D120),
            ),
            Container(
              height: height * 0.25,
              width: 30,
              color: Color(0xff10D120),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    birdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Center(
                child: Text(
              '$counter',
              style: TextStyle(fontSize: 60),
            )),
            Align(alignment: 
            Alignment.bottomCenter,child: Container(
              height : 100 , 
              color :Colors.green,
            ),),
            InkWell(
              onTap: () {
                setState(() {
                  counter++;
                });
                x = x + 0.2;
                this.birdController.animateTo(x);
              },
              child: AnimatedBuilder(
                  builder: builderBird, animation: birdMouvement),
            ),
            AnimatedBuilder(
                builder: builderObstacle, animation: obstacleMouvement),
            
          ],
        ));
  }
}
