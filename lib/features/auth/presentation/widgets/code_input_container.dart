import 'package:flutter/material.dart';

class CodeInputContainer extends StatefulWidget {
  final Function(String)? onCodeComplete;

  const CodeInputContainer({super.key, this.onCodeComplete});

  @override
  State<CodeInputContainer> createState() => _CodeInputContainerState();
}

class _CodeInputContainerState extends State<CodeInputContainer> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE7E7E7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else if (value.isEmpty && index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }

                if (_controllers.every((c) => c.text.isNotEmpty)) {
                  final code = _controllers.map((c) => c.text).join();
                  widget.onCodeComplete?.call(code);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

