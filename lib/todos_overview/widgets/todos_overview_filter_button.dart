import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:forui/forui.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final activeFilter = context.select(
      (TodosOverviewBloc bloc) => bloc.state.filter,
    );

    return FPopoverMenu(
      menuAnchor: Alignment.topRight,
      childAnchor: Alignment.bottomRight,
      builder: (context, controller, child) => FButton.icon(
        onPress: controller.toggle,
        child: const Icon(FLucideIcons.listFilter),
        variant: .ghost,
      ),
      menu: [
        FItemGroup(
          children: [
            FItem(
              title: Text(l10n.todosOverviewFilterAll),
              suffix: activeFilter == TodosViewFilter.all
                  ? const Icon(FLucideIcons.check)
                  : Icon(FLucideIcons.check, color: Colors.transparent),
              onPress: () => context.read<TodosOverviewBloc>().add(
                const TodosOverviewFilterChanged(TodosViewFilter.all),
              ),
            ),
            FItem(
              title: Text(l10n.todosOverviewFilterActiveOnly),
              suffix: activeFilter == TodosViewFilter.activeOnly
                  ? const Icon(FLucideIcons.check)
                  : Icon(FLucideIcons.check, color: Colors.transparent),
              onPress: () => context.read<TodosOverviewBloc>().add(
                const TodosOverviewFilterChanged(TodosViewFilter.activeOnly),
              ),
            ),
            FItem(
              title: Text(l10n.todosOverviewFilterCompletedOnly),
              suffix: activeFilter == TodosViewFilter.completedOnly
                  ? const Icon(FLucideIcons.check)
                  : Icon(FLucideIcons.check, color: Colors.transparent),
              onPress: () => context.read<TodosOverviewBloc>().add(
                const TodosOverviewFilterChanged(TodosViewFilter.completedOnly),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
