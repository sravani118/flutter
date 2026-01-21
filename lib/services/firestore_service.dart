import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore service for managing tasks in real-time
class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  /// Add a new task
  Future<void> addTask(String title, String userId) {
    return tasks.add({
      'title': title,
      'userId': userId,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  /// Update a task
  Future<void> updateTask(String docId, Map<String, dynamic> updates) {
    return tasks.doc(docId).update(updates);
  }

  /// Toggle task completion status
  Future<void> toggleTaskComplete(String docId, bool currentStatus) {
    return tasks.doc(docId).update({'completed': !currentStatus});
  }

  /// Delete a task
  Future<void> deleteTask(String docId) {
    return tasks.doc(docId).delete();
  }

  /// Get tasks for a specific user (real-time stream)
  Stream<QuerySnapshot> getUserTasks(String userId) {
    return tasks
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get all tasks (real-time stream) - useful for demonstration
  Stream<QuerySnapshot> getAllTasks() {
    return tasks.orderBy('createdAt', descending: true).snapshots();
  }
}
