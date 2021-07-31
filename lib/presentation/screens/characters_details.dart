import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breaking_bad/business_logic/cubit/characters_cubit.dart';
import 'package:flutter_breaking_bad/constants/my_colors.dart';
import 'package:flutter_breaking_bad/data/model/characters.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CharacterDetails extends StatelessWidget {
  final Character character;

  const CharacterDetails({Key key, this.character}) : super(key: key);

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        //centerTitle: true,
        title: Text(
          character.nickName,
          style: TextStyle(color: MyColors.myWhite),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: MyColors.myWhite,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent, //to control in legth of each divider
      color: MyColors.myBlack,
      thickness: 2,
    );
  }

  //the text animation of qote
  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: MyColors.myWhite,
            shadows: [
              Shadow(
                blurRadius: 7,
                color: Colors.yellow,
                offset: Offset(0, 0),
              )
            ],
          ),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuoteIndex].quote),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
          //color: MyColors.myYellow,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo(
                          'Job : ',
                          character.jobs
                              .join(' / ')), //to control the list of strings
                      buildDivider(315),
                      characterInfo(
                          'Appeared in : ', character.categoryForTwoSeries),
                      buildDivider(250),
                      characterInfo('Seasons : ',
                          character.appearanceOfSeasons.join(' / ')),
                      buildDivider(280),
                      characterInfo('Status : ', character.statusIfDeadOrAlive),
                      buildDivider(300),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : characterInfo('Better Call Saul Seasons : ',
                              character.betterCallSaulAppearance.join(" / ")),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : buildDivider(150),
                      characterInfo('Actor/Actress : ', character.acotrName),
                      buildDivider(235),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkIfQuotesAreLoaded(state);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
