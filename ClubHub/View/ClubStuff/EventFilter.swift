//
//  EventFilter.swift
//  ClubHub
//
//  Created by Melanija Ilijevski on 6/13/23.
//

import SwiftUI

enum EventFilter: String {
    
    static var allFilters: [EventFilter] {
        
        return [.All, .Volunteering, .Sports, .Hobbies]
    }
    
    case All = "All"
    case Volunteering = "Volunteering"
    case Sports = "Sports"
    case Hobbies = "Hobbies"
    
}
