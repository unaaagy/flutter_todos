import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:forui/forui.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    // return PopupMenuButton<TodosOverviewOption>(
    //   shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
    //   tooltip: l10n.todosOverviewOptionsTooltip,
    //   onSelected: (options) {
    //     switch (options) {
    //       case TodosOverviewOption.toggleAll:
    //         context.read<TodosOverviewBloc>().add(const TodosOverviewToggleAllRequested());
    //       case TodosOverviewOption.clearCompleted:
    //         context.read<TodosOverviewBloc>().add(const TodosOverviewClearCompletedRequested());
    //     }
    //   },
    //   itemBuilder: (context) {
    //     return [
    //       PopupMenuItem(
    //         value: TodosOverviewOption.toggleAll,
    //         enabled: hasTodos,
    //         child: Text(
    //           completedTodosAmount == todos.length
    //               ? l10n.todosOverviewOptionsMarkAllIncomplete
    //               : l10n.todosOverviewOptionsMarkAllComplete,
    //         ),
    //       ),
    //       PopupMenuItem(
    //         value: TodosOverviewOption.clearCompleted,
    //         enabled: hasTodos && completedTodosAmount > 0,
    //         child: Text(l10n.todosOverviewOptionsClearCompleted),
    //       ),
    //     ];
    //   },
    //   icon: const Icon(Icons.more_vert_rounded),
    // );

    return FPopoverMenu(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      builder: (context, controller, child) => FButton.icon(
        onPress: controller.toggle,
        child: const Icon(FLucideIcons.ellipsisVertical),
        variant: .ghost,
      ),
      menu: [
        FItemGroup(
          children: [
            FItem(
              enabled: hasTodos,
              title: Text(
                completedTodosAmount == todos.length
                    ? l10n.todosOverviewOptionsMarkAllIncomplete
                    : l10n.todosOverviewOptionsMarkAllComplete,
              ),
              onPress: () => context.read<TodosOverviewBloc>().add(
                const TodosOverviewToggleAllRequested(),
              ),
            ),
            FItem(
              variant: .destructive,
              enabled: hasTodos && completedTodosAmount > 0,
              title: Text(l10n.todosOverviewOptionsClearCompleted),
              onPress: () => context.read<TodosOverviewBloc>().add(
                const TodosOverviewClearCompletedRequested(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
