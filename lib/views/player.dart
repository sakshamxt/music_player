import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/consts/colors.dart';
import 'package:music_player/consts/text_style.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Player extends StatelessWidget {

  final List<SongModel> data;
  const Player({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<PlayerController>();

    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
            () => Expanded(
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  alignment: Alignment.center,
                  child: QueryArtworkWidget(
                    id: data[controller.playIndex.value].id,
                    type: ArtworkType.AUDIO,
                    artworkHeight: double.infinity,
                    artworkWidth: double.infinity,
                    nullArtworkWidget: const Icon(Icons.music_note, size: 48, color: whiteColor,),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12,),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),

                child: Obx(
                  () => Column(
                    children: [

                      const SizedBox(height: 12,),

                      Text(
                        data[controller.playIndex.value].displayNameWOExt,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: whiteColor,
                          weight: FontWeight.bold,
                          size: 24,
                        ),
                      ),

                      const SizedBox(height: 12,),

                      Text(
                        data[controller.playIndex.value].artist.toString(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: ourStyle(
                          color: whiteColor,
                          weight: FontWeight.normal,
                          size: 20,
                        ),
                      ),

                      const SizedBox(height: 12,),

                      Obx(
                        () => Row(
                          children: [
                            Text(
                              controller.position.value,
                              style: ourStyle(),
                            ),

                            Expanded(
                              child: Slider(
                                thumbColor: sliderColor,
                                inactiveColor: whiteColor,
                                activeColor: sliderColor,
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue){
                                  controller.changeDurationToSeconds(newValue.toInt());
                                  newValue = newValue;
                                }
                              ),
                            ),

                            Text(
                              controller.duration.value,
                              style: ourStyle(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded, color: whiteColor, size: 40,),
                            onPressed: (){
                              controller.playSong(data[controller.playIndex.value-1].uri, controller.playIndex.value-1);
                            },
                          ),

                          Obx(
                              () => CircleAvatar(
                              radius: 35,
                              backgroundColor: whiteColor,
                              child: Transform.scale(
                                scale: 2.5,
                                child: IconButton(
                                  icon: controller.isPlaying.value ? const Icon(Icons.pause, color: bgDarkColor, ) : const Icon(Icons.play_arrow_rounded, color: bgDarkColor, ),
                                  onPressed: (){
                                    if(controller.isPlaying.value){
                                      controller.audioPlayer.pause();
                                      controller.isPlaying(false);
                                    } else {
                                      controller.audioPlayer.play();
                                      controller.isPlaying(true);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded, color: whiteColor, size: 40,),
                            onPressed: (){
                              controller.playSong(data[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
