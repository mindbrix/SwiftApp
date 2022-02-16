//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
    private let textField = TextField()
    private var responderClosure: ResponderClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CellViewCell.self,
            forCellReuseIdentifier: CellViewCell.reuseID)
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = .white
        
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        let bottomConstraint = textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        textField.topConstraint = bottomConstraint
        self.responderClosure = { [weak self] field in
            guard let self = self else { return nil }
            self.textField.become(field)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 / 60, execute: {
                _ = self.textField.becomeFirstResponder()
            })
            return false
        }
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(textField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nc = self.navigationController {
            let hidden = nc.viewControllers.count == 1
            nc.setNavigationBarHidden(hidden, animated: true)
        }
        loadModel()
    }
    
    var loadClosure: ViewModel.Closure = { ViewModel.emptyModel }
    
    func loadModel() {
        model = loadClosure()
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
        return model.sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColor = UIColor(white: 0.9, alpha: 1)
        let headerStyle = Style(
            cell: model.style.cell.withColor(headerColor),
            text: model.style.text)
        let cv = CellView()
        let cell = model.sections[section].header
        cv.apply(cell,
            modelStyle: headerStyle,
            responderClosure: responderClosure)
        cv.fadeToBackground(from: .blue)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(
            withIdentifier: CellViewCell.reuseID,
            for: indexPath)
        tableViewCell.selectionStyle = .none
        
        if let cv = (tableViewCell as? CellViewCell)?.cellView {
            let cell = model.sections[indexPath.section].cells[indexPath.row]
            cv.apply(cell,
                modelStyle: model.style,
                responderClosure: responderClosure)
            cv.fadeToBackground(from: .red)
        }
        return tableViewCell
    }
}
