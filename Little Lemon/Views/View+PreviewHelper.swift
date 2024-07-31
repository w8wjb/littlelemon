//
//  View+PreviewHelper.swift
//  Little Lemon
//
//  Created by Weston Bustraan on 7/30/24.
//

import SwiftUI


extension View {
    
    /** Detect whether the view is being presented in XCode Preview. Some things cause preview to crash */
    var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
