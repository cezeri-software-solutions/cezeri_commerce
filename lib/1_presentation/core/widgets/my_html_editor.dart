import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../../../constants.dart';

class MyHtmlEditor extends StatelessWidget {
  final HtmlEditorController controller;
  final String? initialText;
  final void Function(String? content)? onChangeContent;
  final void Function()? onFocus;
  final void Function()? onBlur;

  const MyHtmlEditor({super.key, required this.controller, this.initialText, this.onChangeContent, this.onFocus, this.onBlur});

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      controller: controller,
      htmlEditorOptions: HtmlEditorOptions(initialText: initialText),
      htmlToolbarOptions: HtmlToolbarOptions(
        toolbarItemHeight: 26,
        textStyle: TextStyles.s13Bold.copyWith(color: Colors.black),
        defaultToolbarButtons: [
          const StyleButtons(),
          const FontSettingButtons(fontSizeUnit: true),
          const FontButtons(clearAll: false),
          const ColorButtons(),
          const ListButtons(listStyles: true),
          const ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),
          const InsertButtons(video: true, audio: false, table: true, hr: true, otherFile: true),
        ],
        customToolbarButtons: [
          InkWell(onTap: () => controller.toggleCodeView(), child: const Icon(Icons.code)),
        ],
        mediaLinkInsertInterceptor: (String url, InsertFileType type) {
          if (type == InsertFileType.video) {
            controller.insertHtml('<video controls src="$url" style="width: 100%; max-width: 600px; height: auto; border: 1px solid #000;"></video>');
            return false;
          }
          return true;
        },
      ),
      callbacks: Callbacks(
        onChangeContent: onChangeContent,
        onFocus: onFocus,
        onBlur: onBlur,
      ),
      otherOptions: const OtherOptions(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 244, 244),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
