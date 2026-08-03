import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';
import 'package:forui/forui.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TodosOverviewBloc(todosRepository: context.read<TodosRepository>())
            ..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FScaffold(
      header: FHeader(
        title: Text(l10n.todosOverviewAppBarTitle),
        suffixes: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                showFToast(
                  variant: .destructive,
                  icon: const Icon(FLucideIcons.cross),
                  context: context,
                  title: Text(l10n.todosOverviewErrorSnackbarText),
                );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final todosOverviewBloc = context
                  .read<TodosOverviewBloc>(); // capture while context is valid

              showFToast(
                context: context,
                title: Text(
                  l10n.todosOverviewTodoDeletedSnackbarText(deletedTodo.title),
                ),
                icon: const Icon(FLucideIcons.info),
                duration: Duration(seconds: 3),
                suffixBuilder: (context, entry) => IntrinsicHeight(
                  child: FButton(
                    onPress: () {
                      todosOverviewBloc.add(
                        const TodosOverviewUndoDeletionRequested(),
                      );
                      entry.dismiss();
                    },
                    child: Text(l10n.todosOverviewUndoDeletionButtonText),
                  ),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(child: Text(l10n.todosOverviewEmptyText));
              }
            }

            return Scrollbar(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: FItemGroup.builder(
                  count: state.filteredTodos.length,
                  itemBuilder: (_, index) {
                    final todo = state.filteredTodos.elementAt(index);
                    return TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        context.read<TodosOverviewBloc>().add(
                          TodosOverviewTodoCompletionToggled(
                            todo: todo,
                            isCompleted: isCompleted,
                          ),
                        );
                      },
                      onDismissed: (_) {
                        context.read<TodosOverviewBloc>().add(
                          TodosOverviewTodoDeleted(todo),
                        );
                      },
                      onTap: () {
                        Navigator.of(
                          context,
                        ).push(EditTodoPage.route(initialTodo: todo));
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
