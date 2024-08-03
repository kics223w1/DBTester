//
//  HistoryService.swift
//  DBTester
//
//  Created by Cao Huy on 31/7/24.
//

import Foundation

class HistoryService : ObservableObject {
    
    static let shared = HistoryService()
    
    @Published var historyModels: [HistoryModel]
    
    init() {
        self.historyModels = []
    }

    func updateHistoryModels(newHistoryModels: [HistoryModel]) {
        DispatchQueue.main.async {
            self.historyModels = newHistoryModels
        }
    }
    
    func getHistoryModelByID(id: UUID) -> HistoryModel? {
        guard let result = self.historyModels.first(where: {$0.id == id}) else {
            return nil
        }
        
        return result
    }
}
