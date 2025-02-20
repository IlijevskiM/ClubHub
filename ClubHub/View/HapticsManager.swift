//
//  SoundManager.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/11/23.
//

import SwiftUI
import AVKit

class HapticsManager {

    static let instance = HapticsManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
