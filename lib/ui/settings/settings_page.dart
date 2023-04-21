import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:superpower/bloc/llm/llm_bloc/llm_bloc.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_creativity.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_model.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';
import 'package:superpower/util/util.dart';

final log = Logging("App Settings");

class SettingPage extends StatelessWidget {
  static const routeName = '/app-settings';

  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('App Settings'),
        ),
        body: SettingWidget(),
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  SettingWidget({super.key});
  final List<LLM> llms = getLLMs();

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final _llmBloc = AppState.llmBloc;
  late final List<LLM> _llms = widget.llms;
  late LLM _llm;
  late LLMModel _llmModel;
  late LLMCreativity _modelCreativity;
  late String _accessKey;
  int selectedVendor = -1;

  @override
  void initState() {
    super.initState();
    log.d('in init state');
    setState(() {
      log.d('in init set state');
      _llm =
          _llms.firstWhere((llm) => llm.isSelected(), orElse: () => _llms[0]);
      _llmModel = _llm.getModel().firstWhere((model) => model.isSelected(),
          orElse: () => _llm.getModel()[0]);
      _modelCreativity = _llmModel.getCreativityLevels().firstWhere(
          (creativityLevel) => creativityLevel.isSelected(),
          orElse: () => _llmModel.getCreativityLevels()[0]);
      _accessKey = _llm.getAccessKey();
    });
    log.d('finishing init state');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _updateVendor(),
          const SizedBox(height: 2),
          _updateModel(),
          const SizedBox(height: 2),
          _updateCreativityLevel(),
          const SizedBox(height: 2),
          _accessKeyText(),
        ],
      ),
    );
  }

  Widget _updateVendor() {
    log.d('in update vendor');
    return ListTile(
      leading: const Icon(
        Icons.villa_rounded,
      ),
      trailing: Focus(
        child: DropdownButton(
          elevation: 5,
          value: _llm.getVendor(),
          style: Theme.of(context).textTheme.displaySmall,
          alignment: Alignment.center,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _llms.map((LLM item) {
            return DropdownMenuItem(
              value: item.getVendor(),
              child: Text(item.getVendor()),
            );
          }).toList(),
          onChanged: (value) {
            log.d('vendor updated');
            setState(() {
              for (var llm in _llms) {
                if (llm.isSelected()) {
                  llm.updateSelectionStatus(false);
                  break;
                }
              }
              for (var llm in _llms) {
                if (llm.getVendor() == value) {
                  llm.updateSelectionStatus(true);
                  _llm = llm;
                  break;
                }
              }
              _accessKey = _llm.getAccessKey();
              _llmBloc.update(UpdateVendorEvent(value as String));
            });
          },
        ),
      ),
      subtitle: const Text('to change model'),
      title: const Text(
        'Select vendor',
        style: Profile.tilesTitleStyle,
      ),
    );
  }

  Widget _updateModel() {
    log.d('in update model');
    return ListTile(
      leading: const Icon(
        Icons.model_training_rounded,
      ),
      trailing: Focus(
        child: DropdownButton(
          elevation: 5,
          value: _llm
              .getModel()
              .firstWhere((model) => model.isSelected())
              .getName(),
          style: Theme.of(context).textTheme.displaySmall,
          alignment: Alignment.center,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _llm.getModel().map((LLMModel item) {
            log.d('--${item..getName()}');
            return DropdownMenuItem(
              value: item.getName(),
              child: Text(item.getName()),
            );
          }).toList(),
          onChanged: (value) {
            log.d('model updated');
            setState(() {
              for (var model in _llm.getModel()) {
                if (model.isSelected()) {
                  model.updateSelectionStatus(false);
                  break;
                }
              }
              for (var model in _llm.getModel()) {
                if (model.getName() == value) {
                  model.updateSelectionStatus(true);
                  _llmModel = model;
                }
              }
              _llmBloc.update(UpdateModelEvent(value as String));
            });
          },
        ),
      ),
      subtitle: const Text('to change model'),
      title: const Text(
        'Select model',
        style: Profile.tilesTitleStyle,
      ),
    );
  }

  Widget _updateCreativityLevel() {
    log.d('in creativity level');
    return ListTile(
      leading: const Icon(
        Icons.camera_sharp,
      ),
      trailing: Focus(
        child: DropdownButton(
          elevation: 5,
          value: _modelCreativity.getName(),
          style: Theme.of(context).textTheme.displaySmall,
          alignment: Alignment.center,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: _llmModel.getCreativityLevels().map((LLMCreativity item) {
            return DropdownMenuItem(
              value: item.getName(),
              child: Text(item.getName()),
            );
          }).toList(),
          onChanged: (value) {
            log.d('creativity updated');
            setState(() {
              for (var creativityLevel in _llmModel.getCreativityLevels()) {
                if (creativityLevel.isSelected()) {
                  creativityLevel.updateSelectionStatus(false);
                  break;
                }
              }
              for (var creativityLevel in _llmModel.getCreativityLevels()) {
                if (creativityLevel.getName() == value) {
                  creativityLevel.updateSelectionStatus(true);
                  _modelCreativity = creativityLevel;
                  break;
                }
              }
              _llmBloc.update(UpdateCreativityLevelEvent(value as String));
            });
          },
        ),
      ),
      subtitle: const Text('to change the creativity'),
      title: const Text(
        'Select creativity level',
        style: Profile.tilesTitleStyle,
      ),
    );
  }

  Widget _accessKeyText() {
    return ListTile(
      leading: const Icon(
        Icons.key_rounded,
      ),
      trailing: 
          Text(
            (_accessKey.isNotEmpty ? _accessKey : "No key added"),
          ),
      subtitle: const Text('click to add access key'),
      title: const Text(
        'Your access key',
        style: Profile.tilesTitleStyle,
      ),
      onTap: () =>
          Navigator.of(context).restorablePush(_showAddAccessKeyDialog),
    );
  }

  static Route<Object?> _showAddAccessKeyDialog(
      BuildContext context, Object? arguments) {
    final accessKeyController = TextEditingController();
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add access key',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          content: TextField(
            controller: accessKeyController,
            decoration: InputDecoration(
              hintText: 'Enter your access key',
              contentPadding: const EdgeInsets.all(15),
              suffixIcon: IconButton(
                  icon: const Icon(Icons.copy_rounded),
                  onPressed: () {
                    Clipboard.getData(Clipboard.kTextPlain).then((value) {
                      final copiedText = (value != null) ? value.text : '';
                      accessKeyController.text = copiedText!;
                    });
                  }),
              // border:
              //     OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
            ),
            onChanged: (value) {
              // do something
            },
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 1, 14, 15),
              child: ElevatedButton(
                onPressed: () {
                  if (accessKeyController.text.isEmpty) {
                    snackbar('Access key can not be empty', isError: true);
                    return;
                  }
                  (AppState.llmBloc)
                      .update(UpdateAccessKeyEvent(accessKeyController.text));
                  Navigator.of(context).pop(true);
                },
                child: const Text("Add"),
              ),
            ),
          ],
        );
      },
    );
  }
}
