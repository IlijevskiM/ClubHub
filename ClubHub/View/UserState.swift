//
//  UserState.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import Foundation

class UserState: ObservableObject{
    var userId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var username: String = ""
    var userIsAddedToGroup: Bool = false
    var userAttemptsForClubOwnerCode: Int = 0
    var userAvatarKey: String {
        userId + ".jpg"
    }
}
