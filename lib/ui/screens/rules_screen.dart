import 'package:fallingfusion/core/constants/rules_texts.dart';
import 'package:fallingfusion/core/enums/block_type.dart';
import 'package:fallingfusion/data/models/block.dart';
import 'package:fallingfusion/data/models/position.dart';
import 'package:fallingfusion/ui/widgets/block_widget.dart';
import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  bool isEnglish = false;

  RulesTexts get texts => isEnglish ? enText : ruText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          texts.appBarTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => isEnglish = !isEnglish),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.translate, color: Colors.black),
            ),
            tooltip: texts.tooltipText,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texts.gameDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            _section(texts.section1Title, texts.section1Text, _mergeExample()),
            const SizedBox(height: 32),
            _section(texts.section2Title, texts.section2Text, _tripleMergeExample()),
            const SizedBox(height: 32),
            _section(texts.section3Title, texts.section3Text, _bombExample()),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String text, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(title),
        const SizedBox(height: 8,),
        _sectionText(text),
        const SizedBox(height: 12,),
        example,
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        const Icon(Icons.bolt, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.35),
    );
  }

  Widget _mergeExample() {
    final blockA = Block(
      value: 16,
      type: BlockType.normal,
      position: Position(0, 0),
    );
    final blockB = Block(
      value: 16,
      type: BlockType.normal,
      position: Position(0, 0),
    );
    final result = Block(
      value: 32,
      type: BlockType.normal,
      position: Position(0, 0),
    );

    return _exampleRow([
      Column(
        children: [
          BlockWidget(block: blockA),
          const Icon(
            Icons.keyboard_double_arrow_down_sharp,
            color: Colors.white,
          ),
          BlockWidget(block: blockB),
        ],
      ),
      const Icon(Icons.arrow_forward, color: Colors.white),
      BlockWidget(block: result),
    ]);
  }

  Widget _tripleMergeExample() {
    final b1 = Block(
      value: 2,
      type: BlockType.normal,
      position: Position(0, 0),
    );
    final b2 = Block(
      value: 2,
      type: BlockType.normal,
      position: Position(0, 0),
    );
    final b3 = Block(
      value: 2,
      type: BlockType.normal,
      position: Position(0, 0),
    );
    final res = Block(
      value: 8,
      type: BlockType.normal,
      position: Position(0, 0),
    );

    return _exampleRow([
      BlockWidget(block: b1),
      BlockWidget(block: b2),
      BlockWidget(block: b3),
      const Icon(Icons.arrow_forward, color: Colors.white),
      BlockWidget(block: res),
    ]);
  }

  Widget _bombExample() {
    final b1 = Block(
      value: 2,
      type: BlockType.bombSmall,
      position: Position(0, 0),
    );
    final b2 = Block(
      value: 2,
      type: BlockType.bombLarge,
      position: Position(0, 0),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(texts.bombSmallLabel, style: TextStyle(fontWeight: FontWeight.bold),),
        const Icon(Icons.keyboard_double_arrow_right_outlined, color: Colors.white),
        const SizedBox(width: 4,),
        BlockWidget(block: b1),
        const SizedBox(width: 24),
        BlockWidget(block: b2),
        const SizedBox(width: 4),
        const Icon(Icons.keyboard_double_arrow_left_outlined, color: Colors.white),
        Text(texts.bombLargeLabel, style: TextStyle(fontWeight: FontWeight.bold),),
      ],
    );
  }

  Widget _exampleRow(List<Widget> widgets) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < widgets.length; i++) ...[
            widgets[i],
            if (i != widgets.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}
