// swiftlint:disable all
import Amplify
import Foundation

extension Outside {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case publishedTime
    case title
    case due
    case hourLimit
    case signees
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let outside = Outside.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Outsides"
    
    model.attributes(
      .primaryKey(fields: [outside.id])
    )
    
    model.fields(
      .field(outside.id, is: .required, ofType: .string),
      .field(outside.publishedTime, is: .required, ofType: .dateTime),
      .field(outside.title, is: .required, ofType: .string),
      .field(outside.due, is: .required, ofType: .dateTime),
      .field(outside.hourLimit, is: .required, ofType: .int),
      .hasMany(outside.signees, is: .optional, ofType: OutsideUser.self, associatedWith: OutsideUser.keys.outside),
      .field(outside.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(outside.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Outside: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}