//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
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
        getModel()
    }
    
    func getModel() {
        model = modelClosure()
    }
    
    var modelClosure: ViewModel.Closure = { ViewModel.emptyModel }
    
    private var model = ViewModel.emptyModel {
        didSet {
            guard oldValue != model else { return }
            self.title = model.title
            let first = self.tableView.firstResponder as? TextField
            first?.canResign = false
            self.tableView.reloadData()
            first?.canResign = true
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cv = CellView()
        cv.apply(
            cell: model.sections[section].header,
            style: model.style,
            isHeader: true)
        cv.fadeToBackground(from: .blue)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvc = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        tvc.selectionStyle = .none
        if let tvc = tvc as? CellViewCell {
            tvc.cellView.apply(
                cell: model.sections[indexPath.section].cells[indexPath.row],
                style: model.style)
            tvc.cellView.fadeToBackground(from: .red)
        }
        return tvc
    }
}
