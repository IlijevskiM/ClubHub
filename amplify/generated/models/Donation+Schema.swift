// swiftlint:disable all
import Amplify
import Foundation

extension Donation {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case publishedTime
    case title
    case location
    case description
    case due
    case signees
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let donation = Donation.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Donations"
    
    model.attributes(
      .primaryKey(fields: [donation.id])
    )
    
    model.fields(
      .field(donation.id, is: .required, ofType: .string),
      .field(donation.publishedTime, is: .required, ofType: .dateTime),
      .field(donation.title, is: .required, ofType: .string),
      .field(donation.location, is: .required, ofType: .string),
      .field(donation.description, is: .required, ofType: .string),
      .field(donation.due, is: .required, ofType: .dateTime),
      .hasMany(donation.signees, is: .optional, ofType: DonationUser.self, associatedWith: DonationUser.keys.donation),
      .field(donation.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(donation.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Donation: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}