import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';

class LicensesView extends StatelessWidget {
  const LicensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        // TODO: text
        title: 'Lizenzen',
      ),
      body: EmptyListWidget(),
    );
  }
}
