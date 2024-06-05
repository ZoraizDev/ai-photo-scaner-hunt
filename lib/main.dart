import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scavenger_hunt_repository/scavenger_hunt_repository.dart';

import 'app/app.dart';
import 'photo/photo_picker.dart';

void main() {
  Bloc.observer = const _AppBlocObserver();

  final photoPicker = PhotoPicker(imagePicker: ImagePicker());

  late final ScavengerHuntRepository repository;

  if (const bool.fromEnvironment('USE_FAKE_DATA', defaultValue: false)) {
    repository = const FakeScavengerHuntRepository();
    print('fake data truee');
  } else {
    // const apiKey = String.fromEnvironment('API_KEY'); 
    const apiKey = 'AIzaSyBL5AJz3FzeCxViEoIIZnV_fztM1siwSrg'; // To use the Gemini API, you'll need an API key. If you don't already have one, create a key in Google AI Studio: https://makersuite.google.com/app/apikey.
    

    
    const projectUrl = String.fromEnvironment('VERTEX_AI_PROJECT_URL');
print('api key $apiKey');
    print('api key $projectUrl');
    final client = projectUrl.isEmpty
        ? ScavengerHuntClient(apiKey: apiKey)
        : ScavengerHuntClient.vertexAi(apiKey: apiKey, projectUrl: projectUrl);

    repository = ScavengerHuntRepository(client: client);
  }

  runApp(App(photoPicker: photoPicker, repository: repository));
}

class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(transition.toString());
  }
}
