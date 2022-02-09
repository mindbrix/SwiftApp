//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
    var modelClosure: ModelClosure = { ViewModel.emptyModel } {
        didSet {
            model = modelClosure()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CellViewCell.self, forCellReuseIdentifier: CellViewCell.reuseID)
        self.view.backgroundColor = .lightGray
    }

    func refresh() {
        model = modelClosure()
    }
    
    private var model = ViewModel.emptyModel {
        didSet {
            guard oldValue != model else { return }
            self.title = model.title
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cv = CellView()
        cv.cell = model.sections[section].header
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = model.sections[indexPath.section].cells[indexPath.row]
        let tvc = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        tvc.selectionStyle = .none
        
        if let tvc = tvc as? CellViewCell {
            tvc.cellView.cell = cell
        }
        return tvc
    }
}
