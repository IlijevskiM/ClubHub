//
//  SafariView.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/17/23.
//

import SwiftUI
import SafariServices

struct SafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariViewWrapper>
    ) {}
}

