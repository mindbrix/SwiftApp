//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
    let monosection = true
    let withheader = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CellViewCell.self, forCellReuseIdentifier: CellViewCell.reuseID)
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nc = self.navigationController else { return }
        nc.setNavigationBarHidden(nc.viewControllers.count == 1, animated: true)
        refresh()
    }
    
    func refresh() {
        model = modelClosure()
    }
    
    var modelClosure: ModelClosure = { ViewModel.emptyModel }
    
    private var model = ViewModel.emptyModel {
        didSet {
            guard oldValue != model else { return }
            self.title = model.title
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        monosection ? min(1, model.sections.count) : model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if monosection {
            return (withheader ? model.sections.count : 0) + model.sections.reduce(0, { x, section in  x + section.cells.count })
        } else {
            return model.sections[section].cells.count
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cv = CellView()
        cv.apply(
            cell: monosection ? .header(caption: model.title) : model.sections[section].header,
            style: model.style)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvc = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        tvc.selectionStyle = .none
        if let tvc = tvc as? CellViewCell {
            let cell: Cell = {
                if monosection {
                    var base = 0
                    for section in model.sections {
                        let end = base + section.cells.count + (withheader ? 1 : 0)
                        if indexPath.row < end {
                            let idx = indexPath.row - base
                            return !withheader ? section.cells[idx] : idx == 0 ? section.header : section.cells[idx - 1]
                        } else {
                            base = end
                        }
                    }
                    return model.sections[indexPath.section].cells[indexPath.row]
                } else {
                    return model.sections[indexPath.section].cells[indexPath.row]
                }
            }()
            tvc.cellView.apply(cell: cell, style: model.style)
            
        }
        return tvc
    }
}
