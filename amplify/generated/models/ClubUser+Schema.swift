// swiftlint:disable all
import Amplify
import Foundation

extension ClubUser {
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
    let clubUser = ClubUser.keys
    
    model.pluralName = "ClubUsers"
    
    model.attributes(
      .index(fields: ["clubId"], name: "byClub"),
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [clubUser.id])
    )
    
    model.fields(
      .field(clubUser.id, is: .required, ofType: .string),
      .belongsTo(clubUser.club, is: .required, ofType: Club.self, targetNames: ["clubId"]),
      .belongsTo(clubUser.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .field(clubUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(clubUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension ClubUser: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}