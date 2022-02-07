//
//  ViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class ViewController: UITableViewController {
    var getModel: (() -> ViewModel) = { ViewModel.emptyModel } {
        didSet {
            model = getModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for type in CellType.allCases {
            self.tableView.register(type.cellClass, forCellReuseIdentifier: type.reuseID)
        }
        self.view.backgroundColor = .lightGray
    }

    func refresh() {
        model = getModel()
    }
    
    private var model = ViewModel.emptyModel {
        didSet {
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch model.sections[section].header {
        case .button(_, _):
            return nil
        case .standard(let title, _, _):
            return title
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = model.sections[indexPath.section].cells[indexPath.row]
        let tvc = tableView.dequeueReusableCell(withIdentifier: cell.type.reuseID, for: indexPath)
        tvc.selectionStyle = .none
        
        if let tvc = tvc as? TableViewCell {
            tvc.cellView.cell = cell
        }
        return tvc
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch model.sections[indexPath.section].cells[indexPath.row] {
        case .button(_, let onTap):
            onTap()
        case .standard(_ , _, let onTap):
            onTap?()
        }
    }
}
