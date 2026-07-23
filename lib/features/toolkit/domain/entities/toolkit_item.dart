import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_constants.dart';

class ToolkitItem extends Equatable {
  const ToolkitItem({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.category,
    this.imageUrl,
    this.subtitle,
    this.author,
    this.tags = const [],
    this.rating,
  });

  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String category; // exercise | meditation | yoga | book | video | cbt
  final String? imageUrl;
  final String? subtitle;
  final String? author;
  final List<String> tags;
  final double? rating;

  @override
  List<Object?> get props => [id, title, category];
}

class ToolkitRepository {
  Future<List<ToolkitItem>> getMindBody(MindBodyType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return switch (type) {
      MindBodyType.exercise => _exercises,
      MindBodyType.meditation => _meditations,
      MindBodyType.yoga => _yogas,
    };
  }

  Future<List<ToolkitItem>> getResources(ResourceType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return switch (type) {
      ResourceType.book => _books,
      ResourceType.video => _videos,
      ResourceType.cbtTechnique => _cbt,
    };
  }

  Future<ToolkitItem?> getById(String id) async {
    final all = [..._exercises, ..._meditations, ..._yogas, ..._books, ..._videos, ..._cbt];
    try {
      return all.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  static const _exercises = [
    ToolkitItem(
      id: 'ex1',
      title: 'Morning Energy',
      description: 'Gentle mobility to wake your body.',
      durationMinutes: 12,
      category: 'exercise',
      subtitle: 'Movement',
    ),
    ToolkitItem(
      id: 'ex2',
      title: 'Strength Builder',
      description: 'Simple bodyweight strength flow.',
      durationMinutes: 15,
      category: 'exercise',
    ),
    ToolkitItem(
      id: 'ex3',
      title: 'Full Body Stretch',
      description: 'Release tension from head to toe.',
      durationMinutes: 10,
      category: 'exercise',
    ),
    ToolkitItem(
      id: 'ex4',
      title: 'Mindful Walk',
      description: 'Walk with awareness and soft breath.',
      durationMinutes: 8,
      category: 'exercise',
    ),
  ];

  static const _meditations = [
    ToolkitItem(
      id: 'med1',
      title: 'Breath Anchor',
      description: 'Return to the present with the breath.',
      durationMinutes: 8,
      category: 'meditation',
    ),
    ToolkitItem(
      id: 'med2',
      title: 'Body Scan Calm',
      description: 'Softly notice each part of the body.',
      durationMinutes: 12,
      category: 'meditation',
    ),
    ToolkitItem(
      id: 'med3',
      title: 'Loving Kindness',
      description: 'Offer warmth to yourself and others.',
      durationMinutes: 10,
      category: 'meditation',
    ),
  ];

  static const _yogas = [
    ToolkitItem(
      id: 'yog1',
      title: 'Sunrise Flow',
      description: 'Easy morning yoga sequence.',
      durationMinutes: 15,
      category: 'yoga',
    ),
    ToolkitItem(
      id: 'yog2',
      title: 'Restorative Evening',
      description: 'Slow poses to unwind before sleep.',
      durationMinutes: 18,
      category: 'yoga',
    ),
    ToolkitItem(
      id: 'yog3',
      title: 'Hip Openers',
      description: 'Release stored stress gently.',
      durationMinutes: 12,
      category: 'yoga',
    ),
  ];

  static const _books = [
    ToolkitItem(
      id: 'bk1',
      title: 'The Power of Now',
      author: 'Eckhart Tolle',
      description: 'A guide to spiritual enlightenment and presence.',
      durationMinutes: 6,
      category: 'book',
      tags: ['Mindfulness', 'Self-growth'],
      rating: 4.8,
    ),
    ToolkitItem(
      id: 'bk2',
      title: 'Atomic Habits',
      author: 'James Clear',
      description: 'Tiny changes, remarkable results — build better habits.',
      durationMinutes: 8,
      category: 'book',
      tags: ['Self-growth', 'Habits'],
      rating: 4.9,
    ),
    ToolkitItem(
      id: 'bk3',
      title: 'Why We Sleep',
      author: 'Matthew Walker',
      description: 'Unlock the power of sleep and dreams.',
      durationMinutes: 10,
      category: 'book',
      tags: ['Sleep'],
      rating: 4.7,
    ),
    ToolkitItem(
      id: 'bk4',
      title: 'The Anxiety Workbook',
      author: 'Heather Sequeira',
      description: 'Practical CBT tools for quieter days.',
      durationMinutes: 7,
      category: 'book',
      tags: ['Anxiety', 'CBT'],
      rating: 4.6,
    ),
  ];

  static const _videos = [
    ToolkitItem(
      id: 'vid1',
      title: 'Understanding Anxiety',
      description: 'A calm walkthrough of how anxiety works in the body.',
      durationMinutes: 18,
      category: 'video',
      tags: ['Anxiety'],
    ),
    ToolkitItem(
      id: 'vid2',
      title: 'Grounding in 5 Minutes',
      description: 'Quick sensory grounding practice on camera.',
      durationMinutes: 5,
      category: 'video',
      tags: ['Grounding'],
    ),
    ToolkitItem(
      id: 'vid3',
      title: 'Sleep Hygiene Basics',
      description: 'Simple evening habits for better rest.',
      durationMinutes: 12,
      category: 'video',
      tags: ['Sleep'],
    ),
  ];

  static const _cbt = [
    ToolkitItem(
      id: 'cbt1',
      title: 'Thought Record',
      description: 'Catch, check, and change unhelpful thoughts.',
      durationMinutes: 10,
      category: 'cbt',
      tags: ['CBT'],
    ),
    ToolkitItem(
      id: 'cbt2',
      title: 'Behavioral Activation',
      description: 'Schedule small meaningful actions.',
      durationMinutes: 8,
      category: 'cbt',
      tags: ['CBT'],
    ),
    ToolkitItem(
      id: 'cbt3',
      title: 'Worry Time',
      description: 'Contain worries to a dedicated window.',
      durationMinutes: 6,
      category: 'cbt',
      tags: ['CBT', 'Anxiety'],
    ),
  ];
}
