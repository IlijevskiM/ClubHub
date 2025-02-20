// swiftlint:disable all
import Amplify
import Foundation

public struct Comment: Model {
  public let id: String
  public var text: String
  public var likes: Int
  public var postID: String
  public var publishedTime: Temporal.DateTime
  public var liked: Bool
  public var userID: String
  public var firstName: String
  public var lastName: String
  public var username: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      text: String,
      likes: Int,
      postID: String,
      publishedTime: Temporal.DateTime,
      liked: Bool,
      userID: String,
      firstName: String,
      lastName: String,
      username: String) {
    self.init(id: id,
      text: text,
      likes: likes,
      postID: postID,
      publishedTime: publishedTime,
      liked: liked,
      userID: userID,
      firstName: firstName,
      lastName: lastName,
      username: username,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      text: String,
      likes: Int,
      postID: String,
      publishedTime: Temporal.DateTime,
      liked: Bool,
      userID: String,
      firstName: String,
      lastName: String,
      username: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.text = text
      self.likes = likes
      self.postID = postID
      self.publishedTime = publishedTime
      self.liked = liked
      self.userID = userID
      self.firstName = firstName
      self.lastName = lastName
      self.username = username
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}