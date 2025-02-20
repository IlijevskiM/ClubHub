// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var clubCategory: String
  public var title: String
  public var bodyText: String?
  public var link: String?
  public var firstName: String
  public var lastName: String
  public var username: String
  public var comments: List<Comment>?
  public var likes: Int
  public var saved: Bool
  public var liked: Bool
  public var publishedTime: Temporal.DateTime
  public var userID: String
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
      comments: List<Comment>? = [],
      likes: Int,
      saved: Bool,
      liked: Bool,
      publishedTime: Temporal.DateTime,
      userID: String) {
    self.init(id: id,
      clubCategory: clubCategory,
      title: title,
      bodyText: bodyText,
      link: link,
      firstName: firstName,
      lastName: lastName,
      username: username,
      comments: comments,
      likes: likes,
      saved: saved,
      liked: liked,
      publishedTime: publishedTime,
      userID: userID,
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
      comments: List<Comment>? = [],
      likes: Int,
      saved: Bool,
      liked: Bool,
      publishedTime: Temporal.DateTime,
      userID: String,
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
      self.comments = comments
      self.likes = likes
      self.saved = saved
      self.liked = liked
      self.publishedTime = publishedTime
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}