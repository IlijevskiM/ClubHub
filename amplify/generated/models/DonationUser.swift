// swiftlint:disable all
import Amplify
import Foundation

public struct DonationUser: Model {
  public let id: String
  public var donation: Donation
  public var user: User
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      donation: Donation,
      user: User) {
    self.init(id: id,
      donation: donation,
      user: user,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      donation: Donation,
      user: User,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.donation = donation
      self.user = user
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}