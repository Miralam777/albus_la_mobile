import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.tag});
  final String tag;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _tecSearch;
  bool _focus = false;

  @override
  void initState() {
    _tecSearch = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _focus = true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tecSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.tag,
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _tecSearch,
              autofocus: _focus,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.tertiaryContainer,
                // TODO: text
                hintText: 'Suchen',
                prefixIcon: Icon(
                  I.search,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
        ),
      ),
      // TODO:
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgUnDrawImage(path: Assets.undraws.writer),
            Text(
              'TODO',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
