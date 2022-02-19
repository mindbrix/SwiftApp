//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

class TableViewController: UITableViewController {
    init(_ loadClosure: @escaping ViewModel.Closure) {
        self.loadClosure = loadClosure
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CellViewCell.self,
            forCellReuseIdentifier: CellViewCell.reuseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        floatingField.backgroundColor = CellStyle().color
        floatingField.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(floatingField)
        let bottomConstraint = floatingField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        floatingField.topConstraint = bottomConstraint
        
        self.responderClosure = { [weak self] field in
            guard let self = self else { return nil }
            self.floatingField.become(field)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 / 60, execute: {
                _ = self.floatingField.becomeFirstResponder()
            })
            return false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(floatingField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nc = self.navigationController {
            let hidden = nc.viewControllers.count == 1
            nc.setNavigationBarHidden(hidden, animated: true)
        }
        loadModel()
    }
    
    var onRotate: ((TableViewController, UIInterfaceOrientation) -> Void)?
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        onRotate?(self, fromInterfaceOrientation)
    }
    
    private let loadClosure: ViewModel.Closure
    private let floatingField = TextField()
    private var responderClosure: ResponderClosure?
   
    var useDescription = false
    func loadModel() {
        model = useDescription ? loadClosure().description() : loadClosure()
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

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let empty = ""
        let titles: [String] = model.sections.map({ _ in empty })
        return model.style.showIndex ? titles : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColor = UIColor(white: 0.9, alpha: 1)
        let headerStyle = ModelStyle(
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
