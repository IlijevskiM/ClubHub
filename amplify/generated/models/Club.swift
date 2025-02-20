// swiftlint:disable all
import Amplify
import Foundation

public struct Club: Model {
  public let id: String
  public var clubProfileKey: String
  public var clubName: String
  public var clubCode: String
  public var publishedTime: Temporal.DateTime
  public var members: List<UserClub>?
  public var creators: [String]
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      clubProfileKey: String,
      clubName: String,
      clubCode: String,
      publishedTime: Temporal.DateTime,
      members: List<UserClub> = [],
      creators: [String] = []) {
    self.init(id: id,
      clubProfileKey: clubProfileKey,
      clubName: clubName,
      clubCode: clubCode,
      publishedTime: publishedTime,
      members: members,
      creators: creators,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      clubProfileKey: String,
      clubName: String,
      clubCode: String,
      publishedTime: Temporal.DateTime,
      members: List<UserClub> = [],
      creators: [String] = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.clubProfileKey = clubProfileKey
      self.clubName = clubName
      self.clubCode = clubCode
      self.publishedTime = publishedTime
      self.members = members
      self.creators = creators
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}