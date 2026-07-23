abstract final class AppConstants {
  static const String appName = 'FreeMind AI';
  static const String tagline = 'Your mind matters.';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const List<String> supportedLanguages = [
    'English',
    'Tamil',
    'Hindi',
    'Telugu',
    'Kannada',
    'Malayalam',
  ];

  static const Map<String, String> languageCodes = {
    'English': 'en',
    'Tamil': 'ta',
    'Hindi': 'hi',
    'Telugu': 'te',
    'Kannada': 'kn',
    'Malayalam': 'ml',
  };

  static const List<String> affirmations = [
    'You are allowed to slow down.',
    'Be kind to your mind today.',
    'One breath at a time.',
    'You are doing your best.',
    'Rest is productive too.',
    'Your feelings are valid.',
    'Progress, not perfection.',
    'You deserve gentleness.',
  ];

  static const List<String> suggestedPrompts = [
    'I feel overwhelmed today',
    'Help me reframe a thought',
    'I need help with a situation',
    'Guide me through a calm check-in',
    'I want to sleep better tonight',
  ];
}

enum AiMode {
  generalSupport('General Support', 'Warm, open listening and support'),
  reframeThought('Reframe Thought', 'Gently challenge unhelpful thoughts'),
  situationSolver('Situation Solver', 'Practical steps for a specific situation');

  const AiMode(this.label, this.description);
  final String label;
  final String description;
}

enum ResourceType { book, video, cbtTechnique }

enum MindBodyType { exercise, meditation, yoga }

enum SleepLibraryType { stories, methods, meditation, sounds }
