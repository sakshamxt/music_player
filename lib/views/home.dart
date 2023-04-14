import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/text_style.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:music_player/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../consts/colors.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    var controller = Get.put(PlayerController());


    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search, color: whiteColor,)),
        ],
        leading: const Icon(Icons.sort_rounded, color: whiteColor,),
        title: Text(
          "Music Player",
          style: ourStyle(
            weight: FontWeight.bold,
            size: 18,
            color: whiteColor,
          ),
        ),
      ),

      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot){
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No song found',
                style: ourStyle(),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Obx(
                          () => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: bgColor,
                          title: Text(
                            snapshot.data![index].displayNameWOExt,
                            style: ourStyle(
                              weight: FontWeight.bold,
                              size: 15,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data![index].artist.toString(),
                            style: ourStyle(
                              weight: FontWeight.normal,
                              size: 12,
                            ),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                              size: 32,
                            ),
                          ),

                          trailing: controller.playIndex.value == index  && controller.isPlaying.value ? const Icon(Icons.play_arrow, color: whiteColor, size: 26,) : null,

                          onTap: () {
                            Get.to(()=> Player(data: snapshot.data!,));
                            controller.playSong(snapshot.data![index].uri, index);
                          },

                        ),
                      ),
                    );
                  }
              ),
            );
          }
        },
      ),
    );
  }
}
