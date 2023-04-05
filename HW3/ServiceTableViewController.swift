//
//  ServiceTableViewController.swift
//  HW3
//
//  Created by Damir Agadilov  on 05.04.2023.
//

import UIKit

import UIKit

class ServiceTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var services: [Service] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ServiceTableViewCell.self, forCellReuseIdentifier: "ServiceCell")
//        tableView.dataSource = self
//        tableView.delegate = self
        
        fetchServices()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceTableViewCell
        
        let service = services[indexPath.row]
        cell.nameLabel.text = service.name
        cell.priceLabel.text = "$\(service.price)"
        cell.timeLabel.text = "\(service.time) mins"
        
        return cell
    }
    
    // MARK: - Private methods
    
    private func fetchServices() {
        guard let url = URL(string: "https://raw.githubusercontent.com/sourcecodebd/Car-Services-API/main/services.json") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: Data is nil")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let services = try decoder.decode([Service].self, from: data)
                self.services = services
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
