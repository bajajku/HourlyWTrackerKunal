import Foundation
struct Day : Codable {
	let maxtemp_c : Double?
	let maxtemp_f : Double?
	let mintemp_c : Double?
	let mintemp_f : Double?
	let avgtemp_c : Double?
	let avgtemp_f : Double?
	let maxwind_mph : Double?
	let maxwind_kph : Double?
	let condition : Condition?

	enum CodingKeys: String, CodingKey {

		case maxtemp_c = "maxtemp_c"
		case maxtemp_f = "maxtemp_f"
		case mintemp_c = "mintemp_c"
		case mintemp_f = "mintemp_f"
		case avgtemp_c = "avgtemp_c"
		case avgtemp_f = "avgtemp_f"
		case maxwind_mph = "maxwind_mph"
		case maxwind_kph = "maxwind_kph"
		case condition = "condition"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		maxtemp_c = try values.decodeIfPresent(Double.self, forKey: .maxtemp_c)
		maxtemp_f = try values.decodeIfPresent(Double.self, forKey: .maxtemp_f)
		mintemp_c = try values.decodeIfPresent(Double.self, forKey: .mintemp_c)
		mintemp_f = try values.decodeIfPresent(Double.self, forKey: .mintemp_f)
		avgtemp_c = try values.decodeIfPresent(Double.self, forKey: .avgtemp_c)
		avgtemp_f = try values.decodeIfPresent(Double.self, forKey: .avgtemp_f)
		maxwind_mph = try values.decodeIfPresent(Double.self, forKey: .maxwind_mph)
		maxwind_kph = try values.decodeIfPresent(Double.self, forKey: .maxwind_kph)
		condition = try values.decodeIfPresent(Condition.self, forKey: .condition)
	}

}
