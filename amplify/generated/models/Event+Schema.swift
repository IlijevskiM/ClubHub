// swiftlint:disable all
import Amplify
import Foundation

extension Event {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case location
    case description
    case date
    case start
    case end
    case capacity
    case type
    case publishedTime
    case signees
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let event = Event.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Events"
    
    model.attributes(
      .primaryKey(fields: [event.id])
    )
    
    model.fields(
      .field(event.id, is: .required, ofType: .string),
      .field(event.title, is: .required, ofType: .string),
      .field(event.location, is: .required, ofType: .string),
      .field(event.description, is: .required, ofType: .string),
      .field(event.date, is: .required, ofType: .dateTime),
      .field(event.start, is: .required, ofType: .dateTime),
      .field(event.end, is: .required, ofType: .dateTime),
      .field(event.capacity, is: .required, ofType: .int),
      .field(event.type, is: .required, ofType: .string),
      .field(event.publishedTime, is: .required, ofType: .dateTime),
      .hasMany(event.signees, is: .optional, ofType: EventUser.self, associatedWith: EventUser.keys.event),
      .field(event.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(event.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Event: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}