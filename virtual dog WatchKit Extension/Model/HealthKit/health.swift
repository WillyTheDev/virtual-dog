//
//  health.swift
//  virtual dog
//
//  Created by William on 06.03.21.
//

import Foundation
import HealthKit

struct HealthKitManager {
    let healthStore = HKHealthStore()
    
    func checkHealthData(){
        if HKHealthStore.isHealthDataAvailable(){
            healthStore.requestAuthorization(toShare: [], read: [HKObjectType.activitySummaryType()]) { (success, error) in
                if !success{
                    print(error!)
                } else {
                    var endDateComponents = Calendar.current.dateComponents([.day, .month, .year, .era], from: Date())
                    endDateComponents.calendar = Calendar.current
                    let predicate = HKQuery.predicateForActivitySummary(with: endDateComponents)
                    let query = HKActivitySummaryQuery(predicate: predicate) { (query, summariesOrNil, errorOrNil) in
                        guard let summary: HKActivitySummary = summariesOrNil?.first else {
                            print("there is no summaries")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            print(summary)
                            
                        }
                    }
                    self.healthStore.execute(query)
                }
            }
        }
    }
}
