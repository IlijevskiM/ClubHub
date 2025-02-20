// swiftlint:disable all
import Amplify
import Foundation

extension Post {
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
    case comments
    case likes
    case saved
    case liked
    case publishedTime
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let post = Post.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Posts"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [post.id])
    )
    
    model.fields(
      .field(post.id, is: .required, ofType: .string),
      .field(post.clubCategory, is: .required, ofType: .string),
      .field(post.title, is: .required, ofType: .string),
      .field(post.bodyText, is: .optional, ofType: .string),
      .field(post.link, is: .optional, ofType: .string),
      .field(post.firstName, is: .required, ofType: .string),
      .field(post.lastName, is: .required, ofType: .string),
      .field(post.username, is: .required, ofType: .string),
      .hasMany(post.comments, is: .optional, ofType: Comment.self, associatedWith: Comment.keys.postID),
      .field(post.likes, is: .required, ofType: .int),
      .field(post.saved, is: .required, ofType: .bool),
      .field(post.liked, is: .required, ofType: .bool),
      .field(post.publishedTime, is: .required, ofType: .dateTime),
      .field(post.userID, is: .required, ofType: .string),
      .field(post.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(post.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Post: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}