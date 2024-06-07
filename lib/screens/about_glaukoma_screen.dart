import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(

          'Education app',

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  const [
            Steps(),
          ],
      ),
    ),
    );
  }
}

class Step {
  Step(
      this.title,
      this.body,
      this.videoId,
      [this.isExpanded = false]
      );


  String title;
  String body;
  bool isExpanded;
  String videoId;
}

List<Step> getSteps() {
  return [

    Step('Бұл не Education app?',' ', '6GMVx6DJ0FE'),
    Step('Қолдану аясы', ' ','niWSC4jibaE' ),
    Step('Функциялармен танысу',' ','6GMVx6DJ0FE' ),
    Step('Базамен байланыс',' ','6GMVx6DJ0FE' ),
    Step('Балдық көрсеткіш',' ','6GMVx6DJ0FE' ),
    Step('Education app PLUS+',' ','6GMVx6DJ0FE' ),
    Step('Жаңартулар',' ','6GMVx6DJ0FE' )

  ];
}
//controller



class Steps extends StatefulWidget {
  const Steps({Key? key}) : super(key: key);
  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {


  final List<Step> _steps = getSteps();
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        child: _renderSteps(),
      ),
    );
  }

  Widget _renderSteps() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _steps[index].isExpanded = !isExpanded;
        });
      },
      children: _steps.map<ExpansionPanel>((Step step) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(step.title),
            );
          },
          body:
              Column(
                children:[

              //     YoutubePlayerBuilder(
              //       player: YoutubePlayer(
              //         controller: YoutubePlayerController(
              //   initialVideoId: step.videoId,
              //   flags: const YoutubePlayerFlags(
              //     autoPlay: false,
              //   ),
              // ),
              //         showVideoProgressIndicator: true,
              //         progressIndicatorColor: Colors.blue,
              //         progressColors: const ProgressBarColors(
              //           playedColor: Colors.blue,
              //           handleColor: Colors.cyan,
              //         ),
              //         onReady: () {
              //
              //         },
              //       ),
              //       builder: (context, player) => player,
              //     ),

                  ListTile(
                    title: Text(step.body),
                   ),

              ],
              ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }
}