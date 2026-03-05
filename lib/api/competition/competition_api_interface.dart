import 'package:bolixo/api/competition/competition_client.dart';
import 'package:bolixo/api/model/competition_model.dart';
import 'package:bolixo/api/model/match_model.dart';
import 'package:bolixo/api/model/team_model.dart';
import 'package:bolixo/main.dart';

abstract class CompetitionApi {
  Future initialize();
  Future<List<CompetitionModel>> getAllCompetitions();
  Future<List<TeamModel>> getAllTeams();
  Future<TeamModel> createTeam(TeamModel team);
  Future createCompetition(CompetitionModel competition, List<int> teamIds);
  Future updateCompetition(CompetitionModel competition, List<int> teamIds);
  Future<List<MatchModel>> getMatchesByCompetition(int competitionId);
  Future saveMatches(int competitionId, List<MatchModel> matches);
  Future updateMatchResult(MatchModel match);

  static CompetitionApi? competitionApi;
  static CompetitionApi getInstance() {
    if (competitionApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          return CompetitionClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.staging:
          return CompetitionClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.production:
          return CompetitionClient(baseUrl: 'https://lixolao-backend.onrender.com');
        case Flavor.local:
          return CompetitionClient(baseUrl: 'http://localhost:8080');
      }
    }
    return competitionApi!;
  }
}
