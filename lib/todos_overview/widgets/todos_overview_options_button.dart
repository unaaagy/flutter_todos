import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:forui/forui.dart';
import 'package:todos_repository/todos_repository.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final todos = context.select<TodosOverviewBloc, List<Todo>>(
      (bloc) => bloc.state.todos,
    );
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return FPopoverMenu(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      builder: (context, controller, child) => FButton.icon(
        onPress: controller.toggle,
        variant: .ghost,
        child: const Icon(FLucideIcons.ellipsisVertical),
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
