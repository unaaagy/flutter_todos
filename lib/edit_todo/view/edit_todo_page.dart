import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';
import 'package:flutter_todos/l10n/l10n.dart';
import 'package:forui/forui.dart';
import 'package:todos_repository/todos_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({Todo? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosRepository>(),
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );

    return FScaffold(
      header: FHeader.nested(
        prefixes: [
          FButton.icon(
            variant: .ghost,
            onPress: () => Navigator.pop(context),
            child: Icon(FLucideIcons.chevronLeft),
          ),
        ],
        title: Text(
          isNewTodo
              ? l10n.editTodoAddAppBarTitle
              : l10n.editTodoEditAppBarTitle,
        ),
      ),

      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: l10n.editTodoSaveButtonTooltip,
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          onPressed: status.isLoadingOrSuccess
              ? null
              : () =>
                    context.read<EditTodoBloc>().add(const EditTodoSubmitted()),
          child: status.isLoadingOrSuccess
              ? const CupertinoActivityIndicator()
              : const Icon(FLucideIcons.check),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 12,
                children: [_TitleField(), _DescriptionField()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return FTextFormField(
      key: const Key('editTodoView_title_textFormField'),
      label: Text(l10n.editTodoTitleLabel),
      hint: hintText,
      control: .managed(
        initial: TextEditingValue(text: state.title),
        onChange: (value) {
          context.read<EditTodoBloc>().add(EditTodoTitleChanged(value.text));
        },
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return FTextFormField(
      label: Text(l10n.editTodoDescriptionLabel),
      key: const Key('editTodoView_description_textFormField'),
      hint: hintText,
      control: .managed(
        initial: TextEditingValue(text: state.description),
        onChange: (value) {
          context.read<EditTodoBloc>().add(
            EditTodoDescriptionChanged(value.text),
          );
        },
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [LengthLimitingTextInputFormatter(300)],
    );
  }
}
