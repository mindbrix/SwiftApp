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
        
        floatingField.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(floatingField)
        floatingField.isHidden = true
        
        self.onBecomeFirstResponder = { [weak self] field in
            guard let self = self
            else { return nil }
            
            self.floatingField.become(field)
            self.floatingField.backgroundColor = self.model.style.cell.color
            self.floatingField.isHidden = false
            
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
        reloadModel()
    }
    
    // MARK: - Resize event handling
    
    var onWillResize: ((TableViewController, CGSize) -> Void)?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.floatingField.isHidden = true
        self.floatingField.resignFirstResponder()
        onWillResize?(self, size)
    }
    
    
    // MARK: - Floating field
    
    private let floatingField = TextField()
    private var onBecomeFirstResponder: OnBecomeFirstResponder?
    
    
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
                let cell = model.sections[indexPath.section].cells[indexPath.row]
                cv.apply(cell,
                    modelStyle: model.style,
                    onBecomeFirstResponder: onBecomeFirstResponder)
                cv.fadeToBackground(from: .green)
                
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
        let cell = model.sections[section].header
        cv.apply(cell,
            modelStyle: headerStyle,
            onBecomeFirstResponder: onBecomeFirstResponder)
        cv.fadeToBackground(from: .blue)
        return cv
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: CellViewCell.reuseID, for: indexPath)
        if let cv = (tableViewCell as? CellViewCell)?.cellView {
            let cell = model.sections[indexPath.section].cells[indexPath.row]
            cv.apply(cell,
                modelStyle: model.style,
                onBecomeFirstResponder: onBecomeFirstResponder)
            cv.fadeToBackground(from: .red)
        }
        tableViewCell.selectionStyle = .none
        return tableViewCell
    }
}
