// swiftlint:disable all
import Amplify
import Foundation

extension DonationUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case donation
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let donationUser = DonationUser.keys
    
    model.pluralName = "DonationUsers"
    
    model.attributes(
      .index(fields: ["donationId"], name: "byDonation"),
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [donationUser.id])
    )
    
    model.fields(
      .field(donationUser.id, is: .required, ofType: .string),
      .belongsTo(donationUser.donation, is: .required, ofType: Donation.self, targetNames: ["donationId"]),
      .belongsTo(donationUser.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .field(donationUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(donationUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension DonationUser: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}