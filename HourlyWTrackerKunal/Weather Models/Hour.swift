import Foundation
struct Hour : Codable {
	let time_epoch : Int?
	let time : String?
	let temp_c : Double?
	let temp_f : Double?
	let is_day : Int?
	let condition : Condition?
	let wind_mph : Double?
	let wind_kph : Double?
	let wind_degree : Int?
	let wind_dir : String?
	let pressure_mb : Double?
	let pressure_in : Double?
	let precip_mm : Double?
	let precip_in : Double?
	let snow_cm : Double?
	let humidity : Int?
	let cloud : Int?
	let feelslike_c : Double?
	let feelslike_f : Double?

	enum CodingKeys: String, CodingKey {

		case time_epoch = "time_epoch"
		case time = "time"
		case temp_c = "temp_c"
		case temp_f = "temp_f"
		case is_day = "is_day"
		case condition = "condition"
		case wind_mph = "wind_mph"
		case wind_kph = "wind_kph"
		case wind_degree = "wind_degree"
		case wind_dir = "wind_dir"
		case pressure_mb = "pressure_mb"
		case pressure_in = "pressure_in"
		case precip_mm = "precip_mm"
		case precip_in = "precip_in"
		case snow_cm = "snow_cm"
		case humidity = "humidity"
		case cloud = "cloud"
		case feelslike_c = "feelslike_c"
		case feelslike_f = "feelslike_f"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		time_epoch = try values.decodeIfPresent(Int.self, forKey: .time_epoch)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		temp_c = try values.decodeIfPresent(Double.self, forKey: .temp_c)
		temp_f = try values.decodeIfPresent(Double.self, forKey: .temp_f)
		is_day = try values.decodeIfPresent(Int.self, forKey: .is_day)
		condition = try values.decodeIfPresent(Condition.self, forKey: .condition)
		wind_mph = try values.decodeIfPresent(Double.self, forKey: .wind_mph)
		wind_kph = try values.decodeIfPresent(Double.self, forKey: .wind_kph)
		wind_degree = try values.decodeIfPresent(Int.self, forKey: .wind_degree)
		wind_dir = try values.decodeIfPresent(String.self, forKey: .wind_dir)
		pressure_mb = try values.decodeIfPresent(Double.self, forKey: .pressure_mb)
		pressure_in = try values.decodeIfPresent(Double.self, forKey: .pressure_in)
		precip_mm = try values.decodeIfPresent(Double.self, forKey: .precip_mm)
		precip_in = try values.decodeIfPresent(Double.self, forKey: .precip_in)
		snow_cm = try values.decodeIfPresent(Double.self, forKey: .snow_cm)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		cloud = try values.decodeIfPresent(Int.self, forKey: .cloud)
		feelslike_c = try values.decodeIfPresent(Double.self, forKey: .feelslike_c)
		feelslike_f = try values.decodeIfPresent(Double.self, forKey: .feelslike_f)
	}

}
