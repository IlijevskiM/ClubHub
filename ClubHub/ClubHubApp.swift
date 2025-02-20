//
//  ClubHubApp.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import SwiftUI

@main
struct ClubHubApp: App {
    
    init(){
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            SessionView()
                .overlay(Splashscreen())
        }
    }
    
    func configureAmplify(){
        do{
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("Successfully configured Amplify")
        }catch{
            print("Failed to initialize Amplify -- \(error)")
        }
    }
}
