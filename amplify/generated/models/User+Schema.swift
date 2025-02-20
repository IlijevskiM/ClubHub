// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case username
    case firstName
    case lastName
    case email
    case userAttemptsForClubOwnerCode
    case posts
    case comments
    case groups
    case userIsAddedToGroup
    case events
    case drafts
    case clubs
    case donations
    case outsides
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Users"
    
    model.attributes(
      .primaryKey(fields: [user.id])
    )
    
    model.fields(
      .field(user.id, is: .required, ofType: .string),
      .field(user.username, is: .required, ofType: .string),
      .field(user.firstName, is: .optional, ofType: .string),
      .field(user.lastName, is: .optional, ofType: .string),
      .field(user.email, is: .optional, ofType: .string),
      .field(user.userAttemptsForClubOwnerCode, is: .required, ofType: .int),
      .hasMany(user.posts, is: .optional, ofType: Post.self, associatedWith: Post.keys.userID),
      .hasMany(user.comments, is: .optional, ofType: Comment.self, associatedWith: Comment.keys.userID),
      .field(user.groups, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(user.userIsAddedToGroup, is: .required, ofType: .bool),
      .hasMany(user.events, is: .optional, ofType: EventUser.self, associatedWith: EventUser.keys.user),
      .hasMany(user.drafts, is: .optional, ofType: Draft.self, associatedWith: Draft.keys.userID),
      .hasMany(user.clubs, is: .optional, ofType: UserClub.self, associatedWith: UserClub.keys.user),
      .hasMany(user.donations, is: .optional, ofType: DonationUser.self, associatedWith: DonationUser.keys.user),
      .hasMany(user.outsides, is: .optional, ofType: OutsideUser.self, associatedWith: OutsideUser.keys.user),
      .field(user.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension User: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}