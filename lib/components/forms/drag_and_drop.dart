//@dart=2.9

import 'package:flutter/widgets.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class DragAndDrop extends StatefulWidget {
  DragAndDrop({Key key}) : super(key: key);

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 36),
      color: AppColors.KELLY_GREEN_500,
      child: Column(
        children: [
          Icon(
            AppIcons.upload,
            size: 64,
          ),
          Text('Drag your Clip to upload or Browse'),
          Text(
              'Duration no more than 60 sec.\nSupported AVI, MOV, MP4 no more than 50 MB.'),
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
    );
  }
}
