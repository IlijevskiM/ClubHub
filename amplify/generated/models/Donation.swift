// swiftlint:disable all
import Amplify
import Foundation

public struct Donation: Model {
  public let id: String
  public var publishedTime: Temporal.DateTime
  public var title: String
  public var location: String
  public var description: String
  public var due: Temporal.DateTime
  public var signees: List<DonationUser>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      publishedTime: Temporal.DateTime,
      title: String,
      location: String,
      description: String,
      due: Temporal.DateTime,
      signees: List<DonationUser>? = []) {
    self.init(id: id,
      publishedTime: publishedTime,
      title: title,
      location: location,
      description: description,
      due: due,
      signees: signees,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      publishedTime: Temporal.DateTime,
      title: String,
      location: String,
      description: String,
      due: Temporal.DateTime,
      signees: List<DonationUser>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.publishedTime = publishedTime
      self.title = title
      self.location = location
      self.description = description
      self.due = due
      self.signees = signees
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}