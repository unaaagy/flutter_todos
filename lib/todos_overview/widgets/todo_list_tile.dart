import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final Todo todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('todoListTile_dismissible_${todo.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      background: Icon(
        FLucideIcons.delete,
        color: context.theme.colors.destructive,
      ),
      child: FTile(
        onPress: onTap,
        title: Text(
          todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: !todo.isCompleted
              ? null
              : TextStyle(
                  color: context.theme.colors.mutedForeground,
                  decoration: TextDecoration.lineThrough,
                ),
        ),
        subtitle: Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        prefix: FCheckbox(
          value: todo.isCompleted,
          onChange: onToggleCompleted == null
              ? null
              : (value) => onToggleCompleted!(value),
        ),
        suffix: onTap == null ? null : const Icon(FLucideIcons.chevronRight),
      ),
    );
  }
}
