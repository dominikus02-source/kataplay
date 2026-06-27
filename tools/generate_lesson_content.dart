import 'dart:convert';
import 'dart:io';
import 'dart:math';

// Mapping of curriculum lessonType -> appropriate step type patterns
// Each entry gives a pattern of step types to use for the 5 questions
final Map<String, List<String>> _stepPatterns = {
  'letterRecognition': ['wordChoice', 'wordChoice', 'pictureChoice', 'wordChoice', 'trueFalse'],
  'soundRecognition': ['wordChoice', 'wordChoice', 'pictureChoice', 'wordChoice', 'trueFalse'],
  'imageMatch': ['wordChoice', 'wordChoice', 'wordChoice', 'pictureChoice', 'trueFalse'],
  'wordChoice': ['wordChoice', 'wordChoice', 'pictureChoice', 'wordChoice', 'trueFalse'],
  'syllableMatch': ['matchPair', 'matchPair', 'wordChoice', 'pictureChoice', 'trueFalse'],
  'sentenceBuild': ['wordOrder', 'wordOrder', 'fillBlank', 'wordChoice', 'trueFalse'],
  'comprehension': ['readingComprehension', 'readingComprehension', 'wordChoice', 'trueFalse', 'fillBlank'],
  'reading': ['storyReading', 'readingComprehension', 'wordChoice', 'pictureChoice', 'trueFalse'],
  'listening': ['listenChoose', 'listenChoose', 'wordChoice', 'trueFalse', 'fillBlank'],
  'storyOrder': ['storySequence', 'storySequence', 'wordChoice', 'wordOrder', 'trueFalse'],
  'writing': ['sentenceChoice', 'fillBlank', 'wordOrder', 'wordChoice', 'trueFalse'],
  'vocabulary': ['wordChoice', 'matchPair', 'fillBlank', 'wordChoice', 'trueFalse'],
  'analysis': ['readingComprehension', 'wordChoice', 'sentenceChoice', 'trueFalse', 'fillBlank'],
  'evaluation': ['readingComprehension', 'sentenceChoice', 'trueFalse', 'fillBlank', 'wordChoice'],
};

final _rng = Random(42); // deterministic seed

String _stepId(int stage, int unit, int lesson, int step) =>
    's${stage}u${unit}l${lesson}_0${step}';

String _worldId(int stage) {
  if (stage == 1) return 'hutan_kata';
  if (stage == 2) return 'sawah_kata';
  if (stage == 3) return 'gunung_kata';
  if (stage == 4) return 'sungai_kata';
  if (stage == 5) return 'lautan_kata';
  if (stage == 6) return 'angkasa_kata';
  return 'kota_kata';
}

int _difficulty(int stage, int unit, int lesson) {
  return (stage * 1 + unit * 0.3 + lesson * 0.2).round().clamp(1, 10);
}

String _pick(List<String> items) => items[_rng.nextInt(items.length)];

List<String> _someExcept(String correct, List<String> pool, int count) {
  final others = [...pool]..remove(correct);
  others.shuffle(_rng);
  return [correct, ...others.take(count - 1)]..shuffle(_rng);
}

Map<String, dynamic> _makeStep(String type, String stepId, int stage, int unit, int lesson, int stepNum, String title) {
  final diff = _difficulty(stage, unit, lesson);
  final world = _worldId(stage);
  final base = <String, dynamic>{
    'id': stepId,
    'level': diff,
    'world': world,
    'xpReward': 10,
  };

  switch (type) {
    case 'wordChoice':
      return {
        ...base,
        'type': 'wordChoice',
        'prompt': 'Pilih jawaban yang tepat!',
        'instruction': title,
        'choices': ['Pilihan A', 'Pilihan B', 'Pilihan C', 'Pilihan D'],
        'correctAnswer': ['Pilihan A'],
        'hint': 'Coba pikirkan baik-baik',
        'difficulty': diff,
      };
    case 'pictureChoice':
      return {
        ...base,
        'type': 'pictureChoice',
        'prompt': 'Pilih gambar yang sesuai!',
        'instruction': title,
        'choices': ['apel', 'bola', 'buku', 'rumah'],
        'correctAnswer': ['apel'],
        'hint': 'Lihat petunjuknya',
        'difficulty': diff,
      };
    case 'trueFalse':
      return {
        ...base,
        'type': 'trueFalse',
        'prompt': 'Apakah pernyataan ini benar?',
        'instruction': title,
        'choices': ['Benar', 'Salah'],
        'correctAnswer': _rng.nextBool() ? ['Benar'] : ['Salah'],
        'hint': 'Baca pernyataan dengan teliti',
        'difficulty': diff,
      };
    case 'matchPair':
      final a1 = 'Kiri ${stepNum}';
      final b1 = 'Kanan ${stepNum}';
      return {
        ...base,
        'type': 'matchPair',
        'prompt': 'Pasangkan yang cocok!',
        'instruction': title,
        'matchPairs': {a1: b1, 'Kiri A': 'Kanan A', 'Kiri B': 'Kanan B'},
        'correctAnswer': ['$a1=$b1'],
        'hint': 'Cocokkan satu per satu',
        'difficulty': diff,
      };
    case 'wordOrder':
      return {
        ...base,
        'type': 'wordOrder',
        'prompt': 'Urutkan kata-kata ini!',
        'instruction': title,
        'choices': ['kata1', 'kata2', 'kata3', 'kata4'],
        'correctAnswer': ['kata1', 'kata2', 'kata3', 'kata4'],
        'hint': 'Urutkan dari kiri ke kanan',
        'difficulty': diff,
      };
    case 'fillBlank':
      return {
        ...base,
        'type': 'fillBlank',
        'prompt': 'Isilah titik-titik di bawah ini!',
        'instruction': title,
        'question': 'Kalimat dengan ____ kosong.',
        'choices': ['jawaban', 'salah', 'benda', 'teman'],
        'correctAnswer': ['jawaban'],
        'hint': 'Pilih kata yang paling tepat',
        'difficulty': diff,
      };
    case 'listenChoose':
      return {
        ...base,
        'type': 'listenChoose',
        'prompt': 'Dengarkan dan pilih jawaban!',
        'instruction': title,
        'choices': ['Pilihan A', 'Pilihan B', 'Pilihan C'],
        'correctAnswer': ['Pilihan A'],
        'hint': 'Dengarkan dengan saksama',
        'difficulty': diff,
      };
    case 'readingComprehension':
      return {
        ...base,
        'type': 'readingComprehension',
        'prompt': 'Baca teks dan jawab pertanyaan!',
        'instruction': title,
        'storyTitle': 'Cerita Singkat',
        'storyText': 'Ini adalah teks bacaan singkat untuk latihan membaca pemahaman. ' *
            3,
        'question': 'Apa yang dibahas dalam teks?',
        'choices': ['Jawaban A', 'Jawaban B', 'Jawaban C', 'Jawaban D'],
        'correctAnswer': ['Jawaban A'],
        'hint': 'Baca teks sekali lagi',
        'difficulty': diff,
      };
    case 'storyReading':
      return {
        ...base,
        'type': 'storyReading',
        'prompt': 'Bacalah cerita berikut!',
        'instruction': title,
        'storyTitle': 'Cerita untuk Dibaca',
        'storyText': 'Pada suatu hari, ada sebuah cerita yang menarik untuk dibaca. ' *
            3,
        'question': 'Apa yang terjadi dalam cerita?',
        'choices': ['Kejadian A', 'Kejadian B', 'Kejadian C'],
        'correctAnswer': ['Kejadian A'],
        'hint': 'Baca cerita dengan saksama',
        'difficulty': diff,
      };
    case 'storySequence':
      return {
        ...base,
        'type': 'storySequence',
        'prompt': 'Urutkan peristiwa berikut!',
        'instruction': title,
        'storyTitle': 'Urutan Cerita',
        'storyText': 'Pertama, kemudian, lalu, akhirnya.',
        'question': 'Apa yang terjadi pertama kali?',
        'choices': ['Peristiwa 1', 'Peristiwa 2', 'Peristiwa 3', 'Peristiwa 4'],
        'correctAnswer': ['Peristiwa 1'],
        'hint': 'Pikirkan urutan waktu',
        'difficulty': diff,
      };
    case 'sentenceChoice':
      return {
        ...base,
        'type': 'sentenceChoice',
        'prompt': 'Pilih kalimat yang benar!',
        'instruction': title,
        'choices': ['Kalimat yang benar.', 'kalimat salah.', 'KALIMAT SALAH.', 'kali mat salah.'],
        'correctAnswer': ['Kalimat yang benar.'],
        'hint': 'Perhatikan huruf kapital dan tanda baca',
        'difficulty': diff,
      };
    default:
      return {
        ...base,
        'type': 'wordChoice',
        'prompt': 'Pilih jawaban yang tepat!',
        'instruction': title,
        'choices': ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', 'Jawaban 4'],
        'correctAnswer': ['Jawaban 1'],
        'hint': 'Coba pikirkan baik-baik',
        'difficulty': diff,
      };
  }
}

void main() {
  final curriculumPath = 'assets/curriculum/curriculum_map.json';
  final file = File(curriculumPath);
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final stages = json['stages'] as List<dynamic>;

  int totalCreated = 0;
  int totalSkipped = 0;

  for (final stage in stages) {
    final stageOrder = stage['order'] as int;
    final units = stage['units'] as List<dynamic>;

    for (final unit in units) {
      final unitOrder = unit['order'] as int;
      final lessons = unit['lessons'] as List<dynamic>;

      for (final lesson in lessons) {
        final lessonId = lesson['id'] as String;
        final lessonTitle = lesson['title'] as String;
        final lessonSubtitle = lesson['subtitle'] as String? ?? '';
        final lessonType = lesson['lessonType'] as String? ?? 'wordChoice';
        final questionCount = lesson['questionCount'] as int? ?? 5;

        // Construct file path
        final dir = 'assets/lessons/stage_${stageOrder.toString().padLeft(2, '0')}/unit_${unitOrder.toString().padLeft(2, '0')}';
        final lessonFile = '$dir/lesson_${lesson['order'].toString().padLeft(3, '0')}.json';

        // Determine lesson order within unit (1-3)
        final lessonOrder = lesson['order'] as int;

        // Check if file already exists
        final f = File(lessonFile);
        if (f.existsSync()) {
          totalSkipped++;
          print('  SKIP $lessonFile (already exists)');
          continue;
        }

        // Create directory
        Directory(dir).createSync(recursive: true);

        // Generate steps
        final pattern = _stepPatterns[lessonType] ?? _stepPatterns['wordChoice']!;
        final steps = <Map<String, dynamic>>[];

        for (int i = 0; i < questionCount; i++) {
          final stepType = pattern[i % pattern.length];
          final stepId = _stepId(stageOrder, unitOrder, lessonOrder, i + 1);
          steps.add(_makeStep(stepType, stepId, stageOrder, unitOrder, lessonOrder, i + 1, lessonSubtitle));
        }

        final lessonJson = {
          'id': lessonId,
          'title': lessonTitle,
          'steps': steps,
        };

        f.writeAsStringSync(
          const JsonEncoder.withIndent('  ').convert(lessonJson),
        );
        totalCreated++;
        print('  CREATE $lessonFile ($lessonType, $questionCount steps)');

        // Update assetPath in the JSON in memory
        lesson['assetPath'] = lessonFile;
      }
    }
  }

  // Write updated curriculum map
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(json),
  );

  print('\nDone! Created: $totalCreated, Skipped: $totalSkipped');
}
