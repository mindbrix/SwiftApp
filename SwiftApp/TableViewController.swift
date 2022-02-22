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
        
        tableView.register(CellViewCell.self,
            forCellReuseIdentifier: CellViewCell.reuseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nc = self.navigationController {
            let hidden = nc.viewControllers.count == 1
            nc.setNavigationBarHidden(hidden, animated: true)
        }
        reloadModel()
    }
    
    
    // MARK: - Resize event handling
    
    var onWillResize: ((TableViewController, CGSize) -> Void)?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        onWillResize?(self, size)
    }
    
    
    // MARK: - ViewModel
    
    var modelClosure: ViewModel.Closure?
    var useDescription = false
    
    func reloadModel() {
        let newModel = modelClosure?() ?? ViewModel.emptyModel
        
        model = useDescription ? newModel.description() : newModel
    }
    
    private var model = ViewModel.emptyModel {
        didSet {
            guard oldValue != model else { return }
            
            self.title = model.title
            if oldValue.style == model.style
                && oldValue.sections.count == model.sections.count {
                self.reapplyVisibleCells()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    private func reapplyVisibleCells() {
        for tableViewCell in tableView.visibleCells {
            if let cv = (tableViewCell as? CellViewCell)?.cellView,
               let indexPath = tableView.indexPath(for: tableViewCell) {
                cv.applyCell(model.sections[indexPath.section].cells[indexPath.row],
                    modelStyle: model.style,
                    fadeColor: .green)
            }
        }
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        model.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.sections[section].cells.count
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let titles: [String] = model.sections.map({ _ in "" })
        return model.style.showIndex ? titles : nil
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerColor = UIColor(white: 0.9, alpha: 1)
        let headerStyle = ModelStyle(
            cell: model.style.cell.withColor(headerColor),
            text: model.style.text)
        let cv = CellView()
        cv.applyCell(model.sections[section].header,
            modelStyle: headerStyle,
            fadeColor: .blue)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        if let cv = (tableViewCell as? CellViewCell)?.cellView {
            cv.applyCell(model.sections[indexPath.section].cells[indexPath.row],
                modelStyle: model.style,
                fadeColor: .red)
        }
        tableViewCell.selectionStyle = .none
        return tableViewCell
    }
}
