// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "db73ebb467f82118e11386d7c2b17c23"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Draft.self)
    ModelRegistry.register(modelType: Event.self)
    ModelRegistry.register(modelType: Donation.self)
    ModelRegistry.register(modelType: Outside.self)
    ModelRegistry.register(modelType: Club.self)
    ModelRegistry.register(modelType: Comment.self)
    ModelRegistry.register(modelType: Post.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EventUser.self)
    ModelRegistry.register(modelType: DonationUser.self)
    ModelRegistry.register(modelType: OutsideUser.self)
    ModelRegistry.register(modelType: UserClub.self)
  }
}