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
  Future deleteCompetition(int competitionId);
  Future<List<MatchModel>> getMatchesByCompetition(int competitionId);
  Future saveMatches(int competitionId, List<MatchModel> matches);
  Future updateMatchResult(MatchModel match);
  Future resetMatchResult(int matchId);

  static CompetitionApi? competitionApi;
  static CompetitionApi getInstance() {
    if (competitionApi == null) {
      switch (MyApp.flavor) {
        case Flavor.mock:
          competitionApi = CompetitionClient(baseUrl: 'https://lixolao2.onrender.com');
          break;
        case Flavor.staging:
          competitionApi = CompetitionClient(baseUrl: 'https://lixolao2.onrender.com');
          break;
        case Flavor.production:
          competitionApi = CompetitionClient(baseUrl: 'https://lixolao2.onrender.com');
          break;
        case Flavor.local:
          competitionApi = CompetitionClient(baseUrl: 'http://localhost:8080');
          break;
      }
    }
    return competitionApi!;
  }
}
