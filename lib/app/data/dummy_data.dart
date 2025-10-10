import 'models/challenge_model.dart';
import 'models/event_model.dart';
import 'models/user_model.dart';

class DummyData {
  static List<UserModel> users = [
    UserModel(id: '1', name: 'CodeNinja', email: 'ninja@code.com', xp: 15200, streak: 12, joinedDate: DateTime(2023, 5, 10)),
    UserModel(id: '2', name: 'AlgoQueen', email: 'queen@algo.com', xp: 14800, streak: 25, joinedDate: DateTime(2023, 3, 22),),
    UserModel(id: '3', name: 'ByteMaster', email: 'master@byte.com', xp: 12500, streak: 5, joinedDate: DateTime(2023, 6, 1)),
    UserModel(id: '4', name: 'ScriptKid', email: 'kid@script.com', xp: 8500, streak: 2, joinedDate: DateTime(2023, 7, 15)),
  ];

  static List<ChallengeModel> challenges = [
    ChallengeModel(id: 'c1', title: 'Recursive Thinking', description: '...', difficulty: 'Hard', category: 'Coding', points: 100),
    ChallengeModel(id: 'c2', title: 'Loop Masters', description: '...', difficulty: 'Medium', category: 'Puzzle', points: 50),
    ChallengeModel(id: 'c3', title: 'Variable Declaration', description: '...', difficulty: 'Easy', category: 'MCQ', points: 10),
  ];

  static List<EventModel> events = [
    EventModel(id: 'e1', title: 'Weekly Code Clash', description: '...', startDate: DateTime.now().subtract(const Duration(days: 2)), endDate: DateTime.now().add(const Duration(days: 5)), isActive: true, participants: 120),
    EventModel(id: 'e2', title: 'The Algorithm Gauntlet', description: '...', startDate: DateTime.now().add(const Duration(days: 10)), endDate: DateTime.now().add(const Duration(days: 17)), participants: 0),
  ];
}