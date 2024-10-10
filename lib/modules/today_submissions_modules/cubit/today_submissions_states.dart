abstract class TodaySubmissionsStates {}

class TodaySubmissionsInitialState extends TodaySubmissionsStates {}

class GetTodaySubmissionsLoadingState extends TodaySubmissionsStates {}

class GetTodaySubmissionsSuccessState extends TodaySubmissionsStates {}

class GetTodaySubmissionsErrorState extends TodaySubmissionsStates {}

class AfterEditSubmissionState extends TodaySubmissionsStates {}

class TasksUpdatedStateViaEventBus extends TodaySubmissionsStates {}

class GetCommentsCountLoadingState extends TodaySubmissionsStates {}

class GetCommentsCountSuccessState extends TodaySubmissionsStates {}

class GetCommentsCountErrorState extends TodaySubmissionsStates {}
