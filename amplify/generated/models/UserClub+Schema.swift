// swiftlint:disable all
import Amplify
import Foundation

extension UserClub {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case club
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userClub = UserClub.keys
    
    model.pluralName = "UserClubs"
    
    model.attributes(
      .index(fields: ["clubId"], name: "byClub"),
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [userClub.id])
    )
    
    model.fields(
      .field(userClub.id, is: .required, ofType: .string),
      .belongsTo(userClub.club, is: .required, ofType: Club.self, targetNames: ["clubId"]),
      .belongsTo(userClub.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .field(userClub.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userClub.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserClub: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}