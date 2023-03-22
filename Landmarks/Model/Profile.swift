//
//  Profile.swift
//  Landmarks
//
//  Created by Breno Harris on 20/03/23.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto = Season.winter
    var goalDate = Date()
    
    static let `default` = Profile(username: "b_harris")
    
    enum Season: String, CaseIterable, Identifiable {
        case spring = "🌷"
        case summer = "☀️"
        case autumn = "🍁"
        case winter = "❄️"
        
        var id: String { rawValue }
    }
}
