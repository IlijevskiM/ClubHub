//
//  OTPViewModel.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/19/23.
//

import SwiftUI

class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    //MARK: OTP Credentials
    @Published var confirmationCode: String = ""
}
