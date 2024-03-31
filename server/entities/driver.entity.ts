/* eslint-disable @typescript-eslint/naming-convention */
import { UserRole } from "../types/common";
import type { IUserBase, ObjectIdNull } from "../types/common";

export enum DriverStatus {
	INACTIVE = "INACTIVE",
	ON_GOING = "ON_GOING",
	ACTIVE = "ACTIVE",
}

export enum VehicleType {
	BIKE = "2",
	CAR = "4",
	CAR7 = "7",
	UNKNOWN = "0",
}

export interface IDriver extends IUserBase {
	driverStatus: DriverStatus;
	vehicleType: VehicleType;
}

export class DriverEntity implements IDriver {
	_id?: ObjectIdNull | undefined;

	phoneNumber = "";

	passwordHash = "";

	fullName?: string | undefined = "";

	phoneNumberVerified = false;

	enable = true;

	active = true;

	driverStatus = DriverStatus.INACTIVE;

	vehicleType = VehicleType.UNKNOWN;

	roles = [UserRole.DRIVER];

	createdAt? = new Date();

	updatedAt? = new Date();
}
