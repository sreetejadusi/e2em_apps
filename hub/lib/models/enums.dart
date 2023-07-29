enum VehicleStatus { none, unassigned, assigned, maintenance, parking }

enum BatteryStatus { none, unassigned, assigned, maintenance, ideal }

enum AllocationStatus { none, done, pending }

AllocationStatus allocationStatusEnum(String s) {
  switch (s) {
    case "done":
      return AllocationStatus.done;
    case "pending":
      return AllocationStatus.pending;
    default:
      return AllocationStatus.none;
  }
}

String allocationStatusMap(AllocationStatus bs) {
  switch (bs) {
    case AllocationStatus.done:
      return "Done";
    case AllocationStatus.pending:
      return "Pending";
    default:
      return "None";
  }
}

BatteryStatus batteryStatusEnum(String s) {
  switch (s) {
    case "assigned":
      return BatteryStatus.assigned;
    case "maintenance":
      return BatteryStatus.maintenance;
    case "ideal":
      return BatteryStatus.ideal;
    default:
      return BatteryStatus.none;
  }
}

String batteryStatusMap(BatteryStatus bs) {
  switch (bs) {
    case BatteryStatus.assigned:
      return "Assigned";
    case BatteryStatus.maintenance:
      return "Under Maintenance";
    case BatteryStatus.ideal:
      return "Ideal";
    default:
      return "None";
  }
}

VehicleStatus vehicleStatusEnum(String s) {
  switch (s) {
    case "assigned":
      return VehicleStatus.assigned;
    case "maintenance":
      return VehicleStatus.maintenance;
    case "parking":
      return VehicleStatus.parking;
    default:
      return VehicleStatus.none;
  }
}

String vehicleStatusMap(VehicleStatus vs) {
  switch (vs) {
    case VehicleStatus.assigned:
      return "Assigned";
    case VehicleStatus.maintenance:
      return "Under Maintenance";
    case VehicleStatus.parking:
      return "In Parking";
    default:
      return "None";
  }
}

enum LoginType { none, driver, hub, admin }

LoginType loginTypeEnum(String s) {
  switch (s) {
    case "driver":
      return LoginType.driver;
    case "hub":
      return LoginType.hub;
    case "admin":
      return LoginType.admin;
    default:
      return LoginType.none;
  }
}


String loginTypeMap(LoginType lt) {
  switch (lt) {
    case LoginType.driver:
      return "driver";
    case LoginType.hub:
      return "hub";
    case LoginType.admin:
      return "admin";
    default:
      return "none";
  }
}
