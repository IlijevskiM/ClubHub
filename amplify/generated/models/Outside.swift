// swiftlint:disable all
import Amplify
import Foundation

public struct Outside: Model {
  public let id: String
  public var publishedTime: Temporal.DateTime
  public var title: String
  public var due: Temporal.DateTime
  public var hourLimit: Int
  public var signees: List<OutsideUser>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      publishedTime: Temporal.DateTime,
      title: String,
      due: Temporal.DateTime,
      hourLimit: Int,
      signees: List<OutsideUser>? = []) {
    self.init(id: id,
      publishedTime: publishedTime,
      title: title,
      due: due,
      hourLimit: hourLimit,
      signees: signees,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      publishedTime: Temporal.DateTime,
      title: String,
      due: Temporal.DateTime,
      hourLimit: Int,
      signees: List<OutsideUser>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.publishedTime = publishedTime
      self.title = title
      self.due = due
      self.hourLimit = hourLimit
      self.signees = signees
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}