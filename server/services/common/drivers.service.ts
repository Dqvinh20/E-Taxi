import type { ActionParams, Context } from "moleculer";
import { Config } from "../../common";
import type { IDriver } from "../../entities";
import { DriverStatus, VehicleType } from "../../entities";
import { createTestDrivers } from "../../helpers/seed";
import { AuthMixin, DbMixin } from "../../mixins";
import type {
	ActionCreateParams,
	DriversServiceSchema,
	DriversThis,
} from "../../types/common/driver";
import { UserRole } from "../../types/common/user";

const phoneNumberRegex = /^0[0-9]{9}$/;

const validateDriverBase: ActionParams = {
	phoneNumber: {
		type: "string",
		min: 10,
		max: 10,
		pattern: phoneNumberRegex,
		singleLine: true,
		trim: true,
	},
	phoneNumberVerified: { type: "boolean", optional: true },
	enable: { type: "boolean", optional: true },
	active: { type: "boolean", optional: true },
	roles: {
		type: "array",
		items: "string",
		enum: Object.values(UserRole),
		optional: true,
	},
	driverStatus: {
		type: "array",
		items: "string",
		enum: Object.values(DriverStatus),
		optional: true,
	},
	vehicleType: {
		type: "array",
		items: "string",
		enum: Object.values(VehicleType),
		optional: true,
	},
};

const DriversService: DriversServiceSchema = {
	name: "drivers",
	authToken: Config.DRIVERS_AUTH_TOKEN,
	mixins: [DbMixin("drivers"), AuthMixin],

	settings: {
		// Available fields in the responses
		fields: [
			"_id",
			"fullName",
			"phoneNumber",
			"phoneNumberVerified",
			"driverStatus",
			"vehicleType",
			"enable",
			"active",
			"roles",
			"createdAt",
			"updatedAt",
		],

		// Validator for the `create` & `insert` actions.
		entityValidator: {
			fullName: { type: "string", min: 3, max: 255, optional: true },
			phoneNumber: {
				type: "string",
				min: 10,
				max: 10,
				pattern: phoneNumberRegex,
				singleLine: true,
				trim: true,
			},
			phoneNumberVerified: { type: "boolean", optional: true },
			enable: { type: "boolean", optional: true },
			active: { type: "boolean", optional: true },
			createdAt: { type: "date", optional: true },
			updatedAt: { type: "date", optional: true },
			roles: {
				type: "array",
				items: "string",
				enum: Object.values(UserRole),
				optional: true,
			},
			driverStatus: {
				type: "array",
				items: "string",
				enum: Object.values(DriverStatus),
				optional: true,
			},
			vehicleType: {
				type: "array",
				items: "string",
				enum: Object.values(VehicleType),
				optional: true,
			},
		},

		indexes: [{ phoneNumber: 1, unique: 1 }],

		accessTokenSecret: Config.ACCESS_TOKEN_SECRET,
		accessTokenExpiry: Config.ACCESS_TOKEN_EXPIRY,

		refreshTokenExpiry: Config.REFRESH_TOKEN_EXPIRY || 24 * 60 * 60 * 7,
		otpExpireMin: Config.OTP_EXPIRE_MIN || 1,
	},

	events: {
		"drivers.updateStatus": {
			async handler(this: DriversThis, ctx: Context<any, any>) {
				await ctx.call("drivers.update", ctx.params);
			},
		},

		"drivers.connected": {
			async handler(this: DriversThis, ctx: Context<any, any>) {
				const driver = await ctx.call<IDriver, any>("drivers.get", {
					id: ctx.meta.user._id,
				});
				if (driver.driverStatus === DriverStatus.INACTIVE) {
					await ctx.emit("drivers.updateStatus", {
						id: ctx.meta.user._id,
						driverStatus: DriverStatus.ACTIVE,
					});
				}
			},
		},

		"drivers.disconnected": {
			async handler(this: DriversThis, ctx: Context<any, any>) {
				const driver = await ctx.call<IDriver, any>("drivers.get", {
					id: ctx.params,
				});
				if (driver.driverStatus === DriverStatus.ACTIVE) {
					await ctx.emit("drivers.updateStatus", {
						id: ctx.params,
						driverStatus: DriverStatus.INACTIVE,
					});
				}
			},
		},
	},

	actions: {
		create: {
			params: {
				...validateDriverBase,
				passwordHash: { type: "string" },
			},
			async handler(this: DriversThis, ctx: Context<ActionCreateParams>) {
				ctx.params.roles = [UserRole.DRIVER];
				const entity = await this._create(ctx, ctx.params);
				return entity;
			},
		},

		list: {
			cache: {
				ttl: 60,
			},
		},

		get: {
			cache: {
				keys: ["id"],
				ttl: 60,
			},
		},

		update: {},

		remove: {},

		find: {
			cache: false,
		},

		active: {
			params: {},
			async handler(this: DriversThis, ctx: Context<any>) {
				const { user } = ctx.meta as any;

				const driver = await ctx.call<IDriver, any>("drivers.get", {
					id: user._id,
				});
				if (driver.driverStatus === DriverStatus.INACTIVE) {
					await ctx.emit("drivers.updateStatus", {
						id: user._id,
						driverStatus: DriverStatus.ACTIVE,
					});
				}
			},
		},

		history: {
			rest: "GET /history",
			async handler(this: DriversThis, ctx: Context<any>) {
				const data = await ctx.call<IDriver, any>("bookingSystem.getDriverHistory", {});
				this.logger.info(data);
				return data;
			},
		},

		inactive: {
			params: {},
			async handler(this: DriversThis, ctx: Context<any>) {
				const { user } = ctx.meta as any;

				const driver = await ctx.call<IDriver, any>("drivers.get", {
					id: user._id,
				});
				if (driver.driverStatus === DriverStatus.ACTIVE) {
					await ctx.emit("drivers.updateStatus", {
						id: user._id,
						driverStatus: DriverStatus.INACTIVE,
					});
				}
			},
		},
	},

	methods: {
		async seedDB(this: DriversThis) {
			const drivers = createTestDrivers(10);
			await this.adapter.insertMany(drivers);
		},
	},

	beforeEntityCreate(entity: any) {
		entity.createdAt = new Date();
		entity.updatedAt = new Date();
		return entity;
	},

	beforeEntityUpdate(entity: any) {
		entity.updatedAt = new Date();
		return entity;
	},

	async started() {},
};

export default DriversService;
