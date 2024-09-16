abstract class ManagerEmployeesStates {}

class ManagerEmployeesInitialState extends ManagerEmployeesStates {}

// manager employees mixin
class GetManagerEmployeesLoadingState extends ManagerEmployeesStates {}

class GetManagerEmployeesSuccessState extends ManagerEmployeesStates {}

class GetManagerEmployeesErrorState extends ManagerEmployeesStates {}
