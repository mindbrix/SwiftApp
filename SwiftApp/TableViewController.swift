//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
    let textField = TextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CellViewCell.self, forCellReuseIdentifier: CellViewCell.reuseID)
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = .white
        
        textField.layer.borderWidth = 0.5
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        self.responderClosure = { [weak self] field in
            self?.textField.text = field.text
            self?.textField.selectedTextRange = field.selectedTextRange
//            self?.textField.becomeFirstResponder()
            return nil
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
            let first = self.tableView.firstResponder as? TextField
            first?.canResign = false
            self.tableView.reloadData()
            first?.canResign = true
        }
    }
    private var responderClosure: ResponderClosure?
    
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
                style: model.style,
                responderClosure: responderClosure)
            tvc.cellView.fadeToBackground(from: .red)
        }
        return tvc
    }
}
