// swiftlint:disable all
import Amplify
import Foundation

extension Comment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case text
    case likes
    case postID
    case publishedTime
    case liked
    case userID
    case firstName
    case lastName
    case username
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let comment = Comment.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Comments"
    
    model.attributes(
      .index(fields: ["postID"], name: "byPost"),
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [comment.id])
    )
    
    model.fields(
      .field(comment.id, is: .required, ofType: .string),
      .field(comment.text, is: .required, ofType: .string),
      .field(comment.likes, is: .required, ofType: .int),
      .field(comment.postID, is: .required, ofType: .string),
      .field(comment.publishedTime, is: .required, ofType: .dateTime),
      .field(comment.liked, is: .required, ofType: .bool),
      .field(comment.userID, is: .required, ofType: .string),
      .field(comment.firstName, is: .required, ofType: .string),
      .field(comment.lastName, is: .required, ofType: .string),
      .field(comment.username, is: .required, ofType: .string),
      .field(comment.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(comment.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Comment: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}