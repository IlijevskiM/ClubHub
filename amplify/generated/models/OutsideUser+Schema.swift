// swiftlint:disable all
import Amplify
import Foundation

extension OutsideUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case outside
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let outsideUser = OutsideUser.keys
    
    model.pluralName = "OutsideUsers"
    
    model.attributes(
      .index(fields: ["outsideId"], name: "byOutside"),
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [outsideUser.id])
    )
    
    model.fields(
      .field(outsideUser.id, is: .required, ofType: .string),
      .belongsTo(outsideUser.outside, is: .required, ofType: Outside.self, targetNames: ["outsideId"]),
      .belongsTo(outsideUser.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .field(outsideUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(outsideUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension OutsideUser: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}