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
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.view.backgroundColor = .lightGray
    }

    func refresh() {
        model = getModel()
    }
    
    private var model = ViewModel.emptyModel {
        didSet {
            switch model.header {
            case .standard(let title, _, _ ):
                self.title = title
            }
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
        case .standard(let title, _, _):
            return title
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.selectionStyle = .none
        switch model.sections[indexPath.section].cells[indexPath.row] {
        case .standard(let title, _, _):
            cell.textLabel?.text = title
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch model.sections[indexPath.section].cells[indexPath.row] {
        case .standard(_, _, let onTap):
            onTap?()
        }
    }
    
    private let reuseIdentifier = "reuseIdentifier"
}

