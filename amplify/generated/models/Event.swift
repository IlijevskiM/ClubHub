// swiftlint:disable all
import Amplify
import Foundation

public struct Event: Model {
  public let id: String
  public var title: String
  public var location: String
  public var description: String
  public var date: Temporal.DateTime
  public var start: Temporal.DateTime
  public var end: Temporal.DateTime
  public var capacity: Int
  public var type: String
  public var publishedTime: Temporal.DateTime
  public var signees: List<EventUser>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String,
      location: String,
      description: String,
      date: Temporal.DateTime,
      start: Temporal.DateTime,
      end: Temporal.DateTime,
      capacity: Int,
      type: String,
      publishedTime: Temporal.DateTime,
      signees: List<EventUser>? = []) {
    self.init(id: id,
      title: title,
      location: location,
      description: description,
      date: date,
      start: start,
      end: end,
      capacity: capacity,
      type: type,
      publishedTime: publishedTime,
      signees: signees,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String,
      location: String,
      description: String,
      date: Temporal.DateTime,
      start: Temporal.DateTime,
      end: Temporal.DateTime,
      capacity: Int,
      type: String,
      publishedTime: Temporal.DateTime,
      signees: List<EventUser>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.location = location
      self.description = description
      self.date = date
      self.start = start
      self.end = end
      self.capacity = capacity
      self.type = type
      self.publishedTime = publishedTime
      self.signees = signees
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}