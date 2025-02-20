// swiftlint:disable all
import Amplify
import Foundation

extension Draft {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case clubCategory
    case title
    case bodyText
    case link
    case firstName
    case lastName
    case username
    case userID
    case savedTime
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let draft = Draft.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Drafts"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [draft.id])
    )
    
    model.fields(
      .field(draft.id, is: .required, ofType: .string),
      .field(draft.clubCategory, is: .required, ofType: .string),
      .field(draft.title, is: .required, ofType: .string),
      .field(draft.bodyText, is: .optional, ofType: .string),
      .field(draft.link, is: .optional, ofType: .string),
      .field(draft.firstName, is: .required, ofType: .string),
      .field(draft.lastName, is: .required, ofType: .string),
      .field(draft.username, is: .required, ofType: .string),
      .field(draft.userID, is: .required, ofType: .string),
      .field(draft.savedTime, is: .required, ofType: .dateTime),
      .field(draft.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(draft.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Draft: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}