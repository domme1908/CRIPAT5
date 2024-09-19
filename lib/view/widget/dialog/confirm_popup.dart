
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:munich_data_quiz/constants/color.dart';
import 'package:munich_data_quiz/view/widget/dialog/popup_dialog_widget.dart';

class ConfirmPopup {

  static Future<void> show(BuildContext context, String title,
  {String? description, String? dismissText, String? acceptText,
    Color dismissColor = MQColor.accentRedAccent,
    Color acceptColor = MQColor.primaryColor,
    Function? onDismiss, Function? onAccept,
  }) async {
    bool _dialogShowing = false;

    dialogCloser() {
      if (Navigator.of(context).canPop() && _dialogShowing) {
        Navigator.of(context).pop();
      }
    }

    dismissText ??= AppLocalizations.of(context)!.cancel;
    acceptText ??= AppLocalizations.of(context)!.continue_;
    onDismiss ??= dialogCloser;

    Widget child = Column(
      children: [
        (description ?? "").isNotEmpty ? Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: Text(description ?? ""),
        ) : const SizedBox(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextButton(
              onPressed: () async {
                if (onDismiss != null) await onDismiss();
                dialogCloser();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(dismissColor),
              ),
              child: Text(dismissText ?? "",
                style: const TextStyle(color: Colors.white),),
            ),
            const SizedBox(width: 30,),
            TextButton(
              onPressed: () async {
                if (onAccept != null) await onAccept();
                dialogCloser();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(acceptColor),
              ),
              child: Text(acceptText ?? "",
                style: const TextStyle(color: Colors.white),),
            ),
          ],
        )
      ],
    );

    _dialogShowing = true;
    await PopupDialogWidget.show(context, title, child);
    _dialogShowing = false;
  }

}