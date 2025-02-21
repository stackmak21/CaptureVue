//
//  TaskManager.swift
//  CaptureVue
//
//  Created by Paris Makris on 7/2/25.
//

import Foundation
import SwiftUI


@MainActor
class TaskManager: ObservableObject {
    var progress = Progress(totalUnitCount: 100)  // ✅ Define progress tracking
    
    var progressValue: Double {
        Double(progress.completedUnitCount) / Double(progress.totalUnitCount)  // ✅ Convert to 0.0 - 1.0
    }

    func startTask(with data: Data) async {
        let batchSize = progress.totalUnitCount  // ✅ Define batch size
        
        for index in 0..<batchSize {
            if progress.isCancelled { break }  // ✅ Check for cancellation
            
            try? await Task.sleep(nanoseconds: 200_000_000)  // ✅ Simulate work
            
            progress.completedUnitCount = index + 1  // ✅ Update progress
        }
    }
}
