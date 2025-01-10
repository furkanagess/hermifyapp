import 'package:flutter/material.dart';
import 'package:hermifyapp/provider/home_view_model.dart';
import 'package:hermifyapp/view/login/signin_view.dart';
import 'package:hermifyapp/view/notification/notifications_view.dart';

import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeViewModel>(context, listen: false).checkUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF191C24),
          body: viewModel.user != null
              ? NotificationsView(viewModel: viewModel)
              : SigninView(viewModel: viewModel),
        );
      },
    );
  }
}
