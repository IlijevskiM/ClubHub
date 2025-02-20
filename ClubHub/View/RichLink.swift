//
//  RickLink.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 7/1/23.
//

import SwiftUI
import LinkPresentation

struct RichLinkModel: Identifiable{
    var id = UUID().uuidString
    // Link preview data
    //preview loading
    var previewLoading: Bool = false
    //meta data
    var linkMetaData: LPLinkMetadata?
    // URL..
    //var linkURL: URL?
}
