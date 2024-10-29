import 'package:quick_card/data/session_repository.dart';
import 'package:quick_card/entity/session.dart';

class SessionService {
  final SessionRepository _sessionRepository = SessionRepository();

  Future<int> createSession(Session session) async {
    return await _sessionRepository.createSession(session);
  }

  Future<Session?> getSessionById(int id) async {
    return await _sessionRepository.getSessionById(id);
  }

  Future<Session?> getCurrentSession() async {
    return await _sessionRepository.getCurrentSession();
  }

  Future<int> updateSession(Session session) async {
    return await _sessionRepository.updateSession(session);
  }

  Future<int> deleteSession(int id) async {
    return await _sessionRepository.deleteSession(id);
  }

  Future<void> clearSession() async {
    Session currentSession = await initializeSessionIfNeeded();
    currentSession.stayLoggedIn = false;
    currentSession.currentUser = null;
    await updateSession(currentSession);
  }

  /// Initializes a session if none exists. Returns the session object.
  Future<Session> initializeSessionIfNeeded() async {
    Session? session = await getCurrentSession();
    if (session == null) {
      // Create a new session if none exists
      session = Session(id: 1);  // Default initialization
      await createSession(session);
    }
    return session;
  }

}
