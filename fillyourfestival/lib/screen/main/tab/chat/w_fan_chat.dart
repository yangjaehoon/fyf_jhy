import 'dart:ui';
import 'package:flutter/material.dart';

class FanChat extends StatefulWidget {
  const FanChat({super.key});

  @override
  State<FanChat> createState() => _FanChatState();
}

class _FanChatState extends State<FanChat> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
            child: Text(
              "Fan Chat Room",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 200,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      // 수평 리스트 아이템을 생성합니다.
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                "assets/image/chat_room/hanyohan_chat.jpg",
                                fit: BoxFit.cover,
                                width: 150,
                                height: 200,
                              ),
                            ),
                          ),
                          ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                width: 150,
                                height: 30,
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("한요한 채팅방"),
                          ),
                        ],
                      );
                    },
                    childCount: 10, // 아이템의 개수
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
