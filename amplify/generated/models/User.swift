// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var username: String
  public var firstName: String?
  public var lastName: String?
  public var email: String?
  public var userAttemptsForClubOwnerCode: Int
  public var posts: List<Post>?
  public var comments: List<Comment>?
  public var groups: [String?]?
  public var userIsAddedToGroup: Bool
  public var events: List<EventUser>?
  public var drafts: List<Draft>?
  public var clubs: List<UserClub>?
  public var donations: List<DonationUser>?
  public var outsides: List<OutsideUser>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      username: String,
      firstName: String? = nil,
      lastName: String? = nil,
      email: String? = nil,
      userAttemptsForClubOwnerCode: Int,
      posts: List<Post>? = [],
      comments: List<Comment>? = [],
      groups: [String?]? = nil,
      userIsAddedToGroup: Bool,
      events: List<EventUser>? = [],
      drafts: List<Draft>? = [],
      clubs: List<UserClub> = [],
      donations: List<DonationUser>? = [],
      outsides: List<OutsideUser>? = []) {
    self.init(id: id,
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      userAttemptsForClubOwnerCode: userAttemptsForClubOwnerCode,
      posts: posts,
      comments: comments,
      groups: groups,
      userIsAddedToGroup: userIsAddedToGroup,
      events: events,
      drafts: drafts,
      clubs: clubs,
      donations: donations,
      outsides: outsides,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      username: String,
      firstName: String? = nil,
      lastName: String? = nil,
      email: String? = nil,
      userAttemptsForClubOwnerCode: Int,
      posts: List<Post>? = [],
      comments: List<Comment>? = [],
      groups: [String?]? = nil,
      userIsAddedToGroup: Bool,
      events: List<EventUser>? = [],
      drafts: List<Draft>? = [],
      clubs: List<UserClub> = [],
      donations: List<DonationUser>? = [],
      outsides: List<OutsideUser>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.username = username
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
      self.userAttemptsForClubOwnerCode = userAttemptsForClubOwnerCode
      self.posts = posts
      self.comments = comments
      self.groups = groups
      self.userIsAddedToGroup = userIsAddedToGroup
      self.events = events
      self.drafts = drafts
      self.clubs = clubs
      self.donations = donations
      self.outsides = outsides
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}