// swiftlint:disable all
import Amplify
import Foundation

public struct OutsideUser: Model {
  public let id: String
  public var outside: Outside
  public var user: User
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      outside: Outside,
      user: User) {
    self.init(id: id,
      outside: outside,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      outside: Outside,
      user: User,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.outside = outside
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}