// swiftlint:disable all
import Amplify
import Foundation

extension Club {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case clubProfileKey
    case clubName
    case clubCode
    case publishedTime
    case members
    case creators
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let club = Club.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Clubs"
    
    model.attributes(
      .primaryKey(fields: [club.id])
    )
    
    model.fields(
      .field(club.id, is: .required, ofType: .string),
      .field(club.clubProfileKey, is: .required, ofType: .string),
      .field(club.clubName, is: .required, ofType: .string),
      .field(club.clubCode, is: .required, ofType: .string),
      .field(club.publishedTime, is: .required, ofType: .dateTime),
      .hasMany(club.members, is: .optional, ofType: UserClub.self, associatedWith: UserClub.keys.club),
      .field(club.creators, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(club.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(club.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Club: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}