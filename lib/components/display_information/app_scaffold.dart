//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tadah_flutter_components/tadah_flutter_components.dart';

class AppScaffold {
  final BuildContext context;
  AppScaffold(this.context);

  void showSnackBar(AppSnackBar snackbar) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (snackbar.icon != null)
                  Icon(
                    snackbar.icon,
                    color: AppColors.MEDIUM_PURPLE_500,
                    size: 20,
                  ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    snackbar.description,
                    softWrap: true,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.WHITE,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (snackbar.buttonText != null)
              CommonButton(
                snackbar.buttonText,
                type: CommonButtonType.Contrast,
                onPressed: snackbar.onPressed,
              ),
          ],
        ),
        backgroundColor:
            snackbar.backgroudColor ?? AppColors.SNACKBAR_BACKGROUND,
        action: snackbar.action,
        animation: snackbar.animation,
        behavior: snackbar.behavior,
        onVisible: snackbar.onVisible,
        width: snackbar.width,
        shape: snackbar.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
        duration: snackbar.duration ?? Duration(seconds: 3),
        elevation: snackbar.elevation,
        padding: snackbar.padding,
        margin: snackbar.margin,
      ),
    );
  }
}
