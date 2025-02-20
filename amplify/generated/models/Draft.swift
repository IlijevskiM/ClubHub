// swiftlint:disable all
import Amplify
import Foundation

public struct Draft: Model {
  public let id: String
  public var clubCategory: String
  public var title: String
  public var bodyText: String?
  public var link: String?
  public var firstName: String
  public var lastName: String
  public var username: String
  public var userID: String
  public var savedTime: Temporal.DateTime
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      clubCategory: String,
      title: String,
      bodyText: String? = nil,
      link: String? = nil,
      firstName: String,
      lastName: String,
      username: String,
      userID: String,
      savedTime: Temporal.DateTime) {
    self.init(id: id,
      clubCategory: clubCategory,
      title: title,
      bodyText: bodyText,
      link: link,
      firstName: firstName,
      lastName: lastName,
      username: username,
      userID: userID,
      savedTime: savedTime,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      clubCategory: String,
      title: String,
      bodyText: String? = nil,
      link: String? = nil,
      firstName: String,
      lastName: String,
      username: String,
      userID: String,
      savedTime: Temporal.DateTime,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.clubCategory = clubCategory
      self.title = title
      self.bodyText = bodyText
      self.link = link
      self.firstName = firstName
      self.lastName = lastName
      self.username = username
      self.userID = userID
      self.savedTime = savedTime
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}