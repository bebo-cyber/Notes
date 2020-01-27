//
//  AllNotesVC.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/25/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit
import CoreData

class AllNotesVC: UIViewController {
    
    @IBOutlet var tableViewNotes: UITableView!
    @IBOutlet var btnSubject: UIButton!
    @IBOutlet var btnDate: UIButton!
    
    var searchText = ""
    var isSortByDate = false {
        didSet {
            btnSubject.isSelected = !isSortByDate
            btnDate.isSelected = isSortByDate
            reloadTable()
        }
    }

    var arrayNotes: [Note] = []
    
    lazy var btnDone: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        tool.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didTabDone(_:)))]
        return tool
    }()
    
    var searchBar: UISearchBar = {
        let searchB = UISearchBar()
        searchB.placeholder = "Search"
        searchB.tintColor = .white
       return searchB
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        isSortByDate = false
        
        tableViewNotes.delegate = self
        tableViewNotes.dataSource = self
        tableViewNotes.estimatedRowHeight = 300
        tableViewNotes.tableFooterView = UIView()
        
        reloadContent()
        searchBar.delegate = self
        searchBar.barStyle = .default
        searchBar.inputAccessoryView = btnDone
        navigationItem.titleView = searchBar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func didTabDone(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    func reloadTable() {
        if isSortByDate {
            arrayNotes.sort(by: { ($0.createdAt ?? Date()) > ($1.createdAt ?? Date()) })
        } else {
            arrayNotes.sort(by: { ($0.subject ?? "") > ($1.subject ?? "") })
        }
        tableViewNotes.reloadData()
    }
    
    func reloadContent() {
        Note.list(filter: searchText) {
            [weak self] (array) in
            self?.arrayNotes = array
            self?.reloadTable()
        }
    }
    


    @IBAction func didTabChangeSort(_ sender: UIButton) {
        isSortByDate = sender == btnDate
    }
    
    @IBAction func didTabAddNew(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "AddNoteVC") as? AddNoteVC {
            navigationController?.pushViewController(vc, animated: true)
            vc.blockDone = {
                [weak self] in
                self?.reloadContent()
            }
        }
    }
    
}
extension AllNotesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        reloadContent()
    }
}
extension AllNotesVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "NoteTableViewCell"
        let cell: NoteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? NoteTableViewCell
        cell.objNote = arrayNotes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(identifier: "AddNoteVC") as? AddNoteVC {
            navigationController?.pushViewController(vc, animated: true)
            vc.objNote = arrayNotes[indexPath.row]
            vc.blockDone = {
                [weak self] in
                self?.reloadContent()
            }
        }
    }
}
