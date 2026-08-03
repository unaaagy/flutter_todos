import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/home/home.dart';
import 'package:flutter_todos/stats/stats.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:forui/forui.dart';

import '../../edit_todo/view/edit_todo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit(), child: const HomeView());
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    return FScaffold(
      child: Scaffold(
        body: IndexedStack(index: selectedTab.index, children: const [TodosOverviewPage(), StatsPage()]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          key: const Key('homeView_addTodo_floatingActionButton'),
          onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
          child: const Icon(Icons.add),
        ),
      ),
      footer: FBottomNavigationBar(
        index: selectedTab.index,
        onChange: (value) => context.read<HomeCubit>().setTab(value == 0 ? HomeTab.todos : HomeTab.stats),
        children: [
          FBottomNavigationBarItem(label: Text('Home'), icon: Icon(FLucideIcons.list)),
          FBottomNavigationBarItem(label: Text('Stats'), icon: Icon(FLucideIcons.chartArea)),
        ],
      ),
    );
  }
}
