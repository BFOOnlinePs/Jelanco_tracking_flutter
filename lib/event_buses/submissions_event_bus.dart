import 'package:event_bus/event_bus.dart';
import 'package:jelanco_tracking_system/models/basic_models/task_submission_model.dart';

// Initialize EventBus globally
EventBus eventBus = EventBus();

// Define a custom event for task updates
class TaskUpdatedEvent {
  final TaskSubmissionModel task;

  TaskUpdatedEvent(this.task);
}
