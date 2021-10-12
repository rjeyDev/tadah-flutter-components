//@dart=2.9

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:html' as html;
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';
import 'package:video_player/video_player.dart';

class DroppedFile {
  final String name;
  final String url;
  final String mime;
  final int bytes;
  final Uint8List data;

  DroppedFile({
    @required this.name,
    @required this.url,
    @required this.mime,
    @required this.bytes,
    @required this.data,
  });

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb > 1
        ? mb.toStringAsFixed(2) + ' MB'
        : kb.toStringAsFixed(2) + ' KB';
  }
}

class DragAndDrop extends StatefulWidget {
  final Function(DroppedFile) onDropped;

  DragAndDrop({@required this.onDropped, Key key}) : super(key: key);

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  DropzoneViewController _controller;
  bool _isDropping = false;
  bool _isDropped = false;
  bool _isVideo = false;
  VideoPlayerController _videoController;
  Uint8List data;

  Color get _backgroundColor => _isDropping
      ? AppColors.BLUE_VIOLET_500_8_WO
      : AppTheme.of(context).transparent;

  // @override
  // void initState() {
  //   super.initState();
  // }

  acceptFile(dynamic file) async {
    var name = await _controller.getFilename(file);
    var url = await _controller.createFileUrl(file);
    var mime = await _controller.getFileMIME(file);
    var bytes = await _controller.getFileSize(file);
    data = await _controller.getFileData(file);

    setState(() {
      _isVideo = mime.substring(0, 5) == 'video';
      _isDropped = true;
    });
    if (_isVideo) {
      final blob = html.Blob([bytes]);
      final link = html.Url.createObjectUrlFromBlob(blob);
      print('link');
      print(link);
      _videoController = VideoPlayerController.network(link)
        ..initialize().then((value) => setState(() {}));
    }
    var droppedFile = DroppedFile(
      name: name,
      url: url,
      mime: mime,
      bytes: bytes,
      data: data,
    );

    widget.onDropped(droppedFile);
  }

  @override
  Widget build(BuildContext context) {
    return _isDropped
        ? _isVideo
            ? _videoController.value.isInitialized
                ? Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      ),
                      Center(
                        child: CommonIconButton(
                          AppIcons.play,
                          backgroundColor: AppColors.WHITE,
                          onPressed: () {
                            _videoController.value.isPlaying
                                ? _videoController.pause()
                                : _videoController.play();
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox()
            : Image.memory(data, fit: BoxFit.cover)
        : DottedBorder(
            borderType: BorderType.RRect,
            strokeWidth: 2,
            color: AppColors.COOL_GRAY_500_38,
            dashPattern: [1, 8],
            strokeCap: StrokeCap.round,
            radius: Radius.circular(8),
            child: Stack(
              children: [
                DropzoneView(
                  onDrop: (file) {
                    setState(() {
                      _isDropping = false;
                    });
                    acceptFile(file);
                    return;
                  },
                  onError: (err) {},
                  onCreated: (controller) => _controller = controller,
                  onHover: () {
                    setState(() {
                      _isDropping = true;
                    });
                  },
                  onLeave: () {
                    setState(() {
                      _isDropping = false;
                    });
                  },
                ),
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 330),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.upload, size: 64),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Drag your Clip to upload or '),
                                AppLink(
                                  'Browse',
                                  onPressed: () async {
                                    var event = await _controller.pickFiles();
                                    if (event.isEmpty) return;
                                    acceptFile(event.first);
                                  },
                                ),
                              ],
                            ),
                            Text(
                              'Duration no more than 60 sec.\nSupported AVI, MOV, MP4 no more than 50 MB.',
                              textAlign: TextAlign.center,
                            ),
                            BasicTextInput(
                              controller: TextEditingController(),
                              prefix: Icon(
                                AppIcons.link,
                                color: AppColors.BLACK_38_WO,
                              ),
                              hintText: 'Or add video link (YouTube or Vimeo)',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
