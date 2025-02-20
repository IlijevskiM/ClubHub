//
//  AvatarView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/17/23.
//

import AmplifyImage
import SwiftUI

enum AvatarState: Equatable {
    case remote(avatarKey: String)
    case local(image: UIImage)
}

struct AvatarView: View {
    let state: AvatarState
    let fromMemoryCache: Bool
    
    init(state: AvatarState, fromMemoryCache: Bool = false) {
        self.state = state
        self.fromMemoryCache = fromMemoryCache
    }
    
    @EnvironmentObject var userState: UserState
    var body: some View {
        switch state {
        case .remote(let avatarKey):
            AmplifyImage(key: avatarKey)
                .kfImage
                .placeholder {
                    Image(systemName: "person.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.gray.opacity(0.9))
                        .padding(21)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .fromMemoryCacheOrRefresh(fromMemoryCache)
                .scaleToFillWidth()
                .clipShape(Circle())
            
        case .local(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
        }
    }
}
