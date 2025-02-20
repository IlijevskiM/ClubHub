// swiftlint:disable all
import Amplify
import Foundation

public struct EventUser: Model {
  public let id: String
  public var event: Event
  public var user: User
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      event: Event,
      user: User) {
    self.init(id: id,
      event: event,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      event: Event,
      user: User,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.event = event
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}