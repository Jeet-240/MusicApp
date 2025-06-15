import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Latest Today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref
              .watch(getAllSongsProvider)
              .when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      song.thumbnail_url
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 180,
                                child: Text(song.song_name,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis
                                ),),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 180,
                                child: Text(song.artist,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Pallete.subtitleText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis
                                  ),),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
