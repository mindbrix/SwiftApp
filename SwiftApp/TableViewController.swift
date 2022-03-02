//
//  TableViewController.swift
//  SwiftApp
//
//  Created by Nigel Barber on 06/02/2022.
//

import UIKit

extension UITableView {
    func visibleSectionIndices(count: Int) -> [Int] {
        let visible = CGRect(
            origin: contentOffset,
            size: bounds.size)
    
        return Array(0 ..< count).filter({ i in
            let rect = style == .plain ? rect(forSection: i) : rectForHeader(inSection: i)
            return visible.intersects(rect)
        })
    }
}

class TableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CellViewCell.self,
            forCellReuseIdentifier: CellViewCell.reuseID)
        tableView.register(CellViewHeaderView.self,
            forHeaderFooterViewReuseIdentifier: CellViewHeaderView.reuseID)
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
        let newModel = modelClosure?() ?? ViewModel()
        
        model = useDescription ? newModel.description() : newModel
    }
    
    private var model = ViewModel() {
        didSet {
            guard oldValue != model else { return }
            
            self.title = model.title
            self.tableView.fadeToBackground(from: UIColor(white: 0.66, alpha: 1))
            
            if oldValue.style == model.style &&
                oldValue.sections.count == model.sections.count &&
                !self.reapplyVisibleHeaders()
            {
                let resizedIndexPaths = self.reapplyVisibleCells()
                self.tableView.reloadRows(at: resizedIndexPaths, with: .fade)
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    private var headerStyle: ModelStyle {
        ModelStyle(
            cell: model.style.cell.withColor(UIColor(white: 0.9, alpha: 1)),
            text: model.style.text
        )
    }
    
    private func reapplyVisibleHeaders() -> Bool {
        var willResize = false
        
        for i in tableView.visibleSectionIndices(count: model.sections.count) {
            if let cv = (tableView.headerView(forSection: i) as? CellViewHeaderView)?.cellView {
                willResize = cv.applyCell(model.sections[i].header,
                                        modelStyle: headerStyle,
                                        fadeColor: .cyan) || willResize
            }
        }
        return willResize
    }
    
    private func reapplyVisibleCells() -> [IndexPath] {
        var resizedIndexPaths: [IndexPath] = []
        
        for tableViewCell in tableView.visibleCells {
            if let cv = (tableViewCell as? CellViewCell)?.cellView,
               let indexPath = tableView.indexPath(for: tableViewCell) {
                let willResize = cv.applyCell(model.sections[indexPath.section].cells[indexPath.row],
                    modelStyle: model.style,
                    fadeColor: .green)
                if willResize {
                    resizedIndexPaths.append(indexPath)
                }
            }
        }
        return resizedIndexPaths
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
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellViewHeaderView.reuseID)
        if let cv = (headerView as? CellViewHeaderView)?.cellView {
            _ = cv.applyCell(model.sections[section].header,
                modelStyle: headerStyle,
                fadeColor: .blue)
        }
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        if let cv = (tableViewCell as? CellViewCell)?.cellView {
            _ = cv.applyCell(model.sections[indexPath.section].cells[indexPath.row],
                modelStyle: model.style,
                fadeColor: .red)
        }
        tableViewCell.selectionStyle = .none
        return tableViewCell
    }
}
