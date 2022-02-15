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
        self.tableView.register(CellViewCell.self, forCellReuseIdentifier: CellViewCell.reuseID)
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = .white
        
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.topConstraint = textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        self.responderClosure = { [weak self] field in
            guard let self = self else { return nil }
            self.textField.become(field)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 / 60, execute: {
                _ = self.textField.becomeFirstResponder()
            })
            return false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(textField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nc = self.navigationController {
            self.navigationController?.setNavigationBarHidden(nc.viewControllers.count == 1, animated: true)
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
        let cv = CellView()
        cv.apply(
            cell: model.sections[section].header,
            modelStyle: model.style,
            isHeader: true,
            responderClosure: responderClosure)
        cv.fadeToBackground(from: .blue)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvc = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        tvc.selectionStyle = .none
        if let tvc = tvc as? CellViewCell {
            tvc.cellView.apply(
                cell: model.sections[indexPath.section].cells[indexPath.row],
                modelStyle: model.style,
                responderClosure: responderClosure)
            tvc.cellView.fadeToBackground(from: .red)
        }
        return tvc
    }
}
