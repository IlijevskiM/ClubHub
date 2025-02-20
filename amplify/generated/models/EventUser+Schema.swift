// swiftlint:disable all
import Amplify
import Foundation

extension EventUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case event
    case user
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let eventUser = EventUser.keys
    
    model.pluralName = "EventUsers"
    
    model.attributes(
      .index(fields: ["eventId"], name: "byEvent"),
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [eventUser.id])
    )
    
    model.fields(
      .field(eventUser.id, is: .required, ofType: .string),
      .belongsTo(eventUser.event, is: .required, ofType: Event.self, targetNames: ["eventId"]),
      .belongsTo(eventUser.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .field(eventUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(eventUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension EventUser: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}