import 'package:quick_card/repository/session_repository.dart';
import 'package:quick_card/entity/session.dart';

class SessionService {
  final SessionRepository _sessionRepository = SessionRepository();

  // Create new Session
  Future<int> createSession(Session session) async {
    return await _sessionRepository.createSession(session);
  }

  // Get current Session
  Future<Session?> getCurrentSession() async {
    return await _sessionRepository.getCurrentSession();
  }

  // Get current User id
  Future<int> getCurrentUserId() async {
    return await _sessionRepository.getCurrentUserId();
  }

  // Update Session
  Future<int> updateSession(Session session) async {
    return await _sessionRepository.updateSession(session);
  }

  // Delete Session by id
  Future<int> deleteSession(int id) async {
    return await _sessionRepository.deleteSession(id);
  }

  // Clear Session
  Future<void> clearSession() async {
    Session currentSession = await initializeSessionIfNeeded();
    currentSession.stayLoggedIn = false;
    currentSession.currentUserId = null;
    await updateSession(currentSession);
  }

  // Initializes a session if none exists. Returns the session object.
  Future<Session> initializeSessionIfNeeded() async {
    Session? session = await getCurrentSession();
    if (session == null) {
      // Create a new session if none exists
      session = Session(id: 1); // Default initialization
      await createSession(session);
    }
    return session;
  }
}
