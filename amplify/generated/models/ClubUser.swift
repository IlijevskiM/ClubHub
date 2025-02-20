// swiftlint:disable all
import Amplify
import Foundation

public struct ClubUser: Model {
  public let id: String
  public var club: Club
  public var user: User
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      club: Club,
      user: User) {
    self.init(id: id,
      club: club,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      club: Club,
      user: User,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.club = club
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}