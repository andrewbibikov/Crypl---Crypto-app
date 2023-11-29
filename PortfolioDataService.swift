//
//  PortfolioDataService.swift
//  Crypl
//
//  Created by Andrei Bibikov on 07.07.2023.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container = NSPersistentContainer(name: "PortfolioContainer")
   
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
        
        getPortfolio()
    }
    
    //MARK: Public
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        // Checks if coin is already in portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
        
    }
    
    
    //MARK: Private
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
                } catch let error {
                    print("Error fetching. \(error)")
                }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        save()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        save()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        save()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
            getPortfolio()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
   
    
}
