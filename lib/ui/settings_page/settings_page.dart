import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:superpower/bloc/llm/llm_bloc/llm_bloc.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_creativity.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/llm_model.dart';
import 'package:superpower/bloc/llm/llm_bloc/model/user_llm_preference.dart';
import 'package:superpower/shared/widgets/page_loading.dart';
import 'package:superpower/util/app_state.dart';
import 'package:superpower/util/config.dart';
import 'package:superpower/util/constants.dart';
import 'package:superpower/util/logging.dart';

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
        body: const SettingWidget(),
      ),
    );
  }
}

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  final _llmBloc = AppState.llmBloc;
  late final List<LLM> _llms;
  late LLM _llm;
  late LLMModel _llmModel;
  late LLMCreativity _modelCreativity;
  String _accessKey = "";
  late UserLLMPreference _userLLMPreference;
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    log.d('in init state');
    syncLLMWithUserPreference();
    log.d('finishing init state');
  }

  void syncLLMWithUserPreference() async {
    // if (!dataFetched) {
    await _llmBloc
        .update(const GetLLMsEvent())
        .then((value) => _llms = value as List<LLM>);
    await _llmBloc
        .update(const GetUserLLMPreferenceEvent())
        .then((value) => _userLLMPreference = value as UserLLMPreference);
    log.d('user preference has ${_userLLMPreference.getModel()}');
    dataFetched = true;
    // }
    setState(() {
      log.d('in init set state');
      _llm = _llms.firstWhere(
          (llm) => (llm.getId() == _userLLMPreference.getVendor()),
          orElse: () => _llms[0]);
      _llm.updateSelectionStatus(true);
      _llmModel = _llm.getModel().firstWhere(
          (model) => (model.getId() == _userLLMPreference.getModel()),
          orElse: () => _llm.getModel()[0]);
      _llmModel.updateSelectionStatus(true);
      _modelCreativity = _llmModel.getCreativityLevels().firstWhere(
          (creativityLevel) => (creativityLevel.getId() ==
              _userLLMPreference.getCreativityLevel()),
          orElse: () => _llmModel.getCreativityLevels()[0]);
      _modelCreativity.updateSelectionStatus(true);
      if (_userLLMPreference.getAccessKey() != null &&
          _userLLMPreference
              .getAccessKey()
              .containsKey(_userLLMPreference.getVendor())) {
        _accessKey =
            _userLLMPreference.getAccessKey()[_userLLMPreference.getVendor()]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return !dataFetched
        ? const PageLoading()
        : SingleChildScrollView(
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
                _accessKeyText(context),
                const SizedBox(height: 61),
                _saveButton(),
              ],
            ),
          );
  }

  Widget _updateVendor() {
    log.d('in update vendor with ${_llm.toJson().toString()}');
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
              String id = "1";
              for (var llm in _llms) {
                if (llm.getVendor() == value) {
                  llm.updateSelectionStatus(true);
                  _llm = llm;
                  id = llm.getId();
                  _llm.getModel()[0].updateSelectionStatus(true);
                  _llm
                      .getModel()[0]
                      .getCreativityLevels()[0]
                      .updateSelectionStatus(true);
                  break;
                }
              }
              _llmBloc.update(UpdateVendorEvent(id));
              _llmBloc.update(const UpdateModelEvent("1"));
              _llmBloc.update(const UpdateCreativityLevelEvent("1"));
              _accessKey = _userLLMPreference.getAccessKey().containsKey(id)
                  ? _userLLMPreference.getAccessKey()[id]!
                  : "";
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
    log.d('in update model with ${_llm.getModel().toString()}');
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
            return DropdownMenuItem(
              value: item.getName(),
              child: Text(item.getName()),
            );
          }).toList(),
          onChanged: (value) {
            log.d('model updated..');
            setState(() {
              for (var model in _llm.getModel()) {
                if (model.isSelected()) {
                  model.updateSelectionStatus(false);
                  break;
                }
              }
              String id = "1";
              for (var model in _llm.getModel()) {
                if (model.getName() == value) {
                  model.updateSelectionStatus(true);
                  id = model.getId();
                  _llmModel = model;
                  break;
                }
              }
              _llmBloc.update(UpdateModelEvent(id));
              _llmBloc.update(const UpdateCreativityLevelEvent("1"));
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
              String id = "1";
              for (var creativityLevel in _llmModel.getCreativityLevels()) {
                if (creativityLevel.getName() == value) {
                  creativityLevel.updateSelectionStatus(true);
                  _modelCreativity = creativityLevel;
                  id = creativityLevel.getId();
                  break;
                }
              }
              _llmBloc.update(UpdateCreativityLevelEvent(id));
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

  Widget _accessKeyText(BuildContext context) {
    log.d('access key text $_accessKey');
    return ListTile(
      leading: const Icon(
        Icons.key_rounded,
      ),
      trailing: Text(
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

  Route<Object?> _showAddAccessKeyDialog(
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
                  Map<String, String> keys = <String, String>{};
                  keys[_llm.getId()] = accessKeyController.text;
                  (AppState.llmBloc).update(UpdateAccessKeyEvent(keys));
                  setState(() {
                    _accessKey = accessKeyController.text;
                    _llm.setAccessKey(_accessKey);
                  });
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

  Widget _saveButton() {
    return Focus(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
        child: ElevatedButton(
          onPressed: savePreference,
          child: const Text(
            'Save Preference',
          ),
        ),
      ),
    );
  }

  void savePreference() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PageLoading(),
    );

    _llmBloc
        .update(const UpdateUserLLMPreferenceEvent())
        .then((value) => {
              log.d("caught success............."),
              Navigator.of(context).pop(),
              GoRouter.of(context).pop(),
            })
        .catchError((error) => {
              log.d("caught error.............$error"),
              Navigator.of(context).pop()
            });

    log.d("reached here.............");
  }
}
