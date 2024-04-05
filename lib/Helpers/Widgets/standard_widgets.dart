import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 236, 249, 255),
      child: const Center(
        child: SizedBox(
          height: 35.0,
          width: 35.0,
          child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 91, 170, 255),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 184, 218, 255)),
              strokeWidth: 8),
        ),
      ),
    );
  }
}

class NoticeDialog extends StatelessWidget {
  final String content;
  const NoticeDialog({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Notice',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Text(content),
      actions: [
        TextButton(
            child: const Text(
              "OK",
              style: TextStyle(color: Color.fromARGB(255, 52, 66, 117)),
            ),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}

class LoadingComment extends StatelessWidget {
  const LoadingComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: const Center(
        child: SizedBox(
          height: 10.0,
          width: 10.0,
          child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 187, 187, 187),
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 236, 236, 236)),
              strokeWidth: 3),
        ),
      ),
    );
  }
}

class SelectableTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon leadingIcon;
  final List<String> options;
  final Function updateCallback;
  final Function clearCallback;
  const SelectableTextForm(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.leadingIcon,
      required this.options,
      required this.updateCallback,
      required this.clearCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: const EdgeInsets.only(right: 40, left: 40),
        child: TypeAheadFormField(
          hideOnLoading: true,
          hideOnEmpty: true,
          textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) => updateCallback(value),
              controller: controller,
              decoration: InputDecoration(
                focusColor: const Color.fromARGB(255, 51, 64, 113),
                icon: leadingIcon,
                border: InputBorder.none,
                labelText: labelText,
                suffixIcon: IconButton(
                  onPressed: () {
                    clearCallback();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              autofocus: true,
              style: const TextStyle(color: Color.fromARGB(255, 51, 64, 113))),
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          errorBuilder: (context, error) {
            return NoticeDialog(content: '$error');
          },
          suggestionsCallback: (pattern) {
            List<String> matches = [];
            if (pattern == '') {
              return matches;
            } else {
              matches.addAll(options);
              matches.retainWhere((matches) {
                return matches.toLowerCase().contains(pattern.toLowerCase());
              });
              return matches;
            }
          },
          onSuggestionSelected: (suggestion) {
            updateCallback(suggestion);
            controller.text = suggestion;
          },
        ));
  }
}
