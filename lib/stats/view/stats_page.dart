import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/stats/stats.dart';
import 'package:forui/forui.dart';
import 'package:todos_repository/todos_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatsBloc(todosRepository: context.read<TodosRepository>())
            ..add(const StatsSubscriptionRequested()),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return FScaffold(
      header: FHeader(title: Text(l10n.statsAppBarTitle)),
      child: Column(
        children: [
          FTileGroup(
            children: [
              FTile(
                key: const Key('statsView_completedTodos_listTile'),
                prefix: const Icon(FLucideIcons.check),
                title: Text(l10n.statsCompletedTodoCountLabel),
                suffix: Text(
                  '${state.completedTodos}',
                  style: textTheme.headlineSmall,
                ),
              ),
              FTile(
                key: const Key('statsView_activeTodos_listTile'),
                prefix: const Icon(Icons.radio_button_unchecked_rounded),
                title: Text(l10n.statsActiveTodoCountLabel),
                suffix: Text(
                  '${state.activeTodos}',
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
