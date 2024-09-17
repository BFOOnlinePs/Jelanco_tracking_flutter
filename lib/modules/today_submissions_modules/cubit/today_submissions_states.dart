abstract class TodaySubmissionsStates {}

class TodaySubmissionsInitialState extends TodaySubmissionsStates {}

class GetTodaySubmissionsLoadingState extends TodaySubmissionsStates {}

class GetTodaySubmissionsSuccessState extends TodaySubmissionsStates {}

class GetTodaySubmissionsErrorState extends TodaySubmissionsStates {}

class AfterEditSubmissionState extends TodaySubmissionsStates {}
