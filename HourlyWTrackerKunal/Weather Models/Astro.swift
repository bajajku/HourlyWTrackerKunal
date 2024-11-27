import Foundation
struct Astro : Codable {
	let sunrise : String?
	let sunset : String?

	enum CodingKeys: String, CodingKey {

		case sunrise = "sunrise"
		case sunset = "sunset"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sunrise = try values.decodeIfPresent(String.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(String.self, forKey: .sunset)
	}

}
