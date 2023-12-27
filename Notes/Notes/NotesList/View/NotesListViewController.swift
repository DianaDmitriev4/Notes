//
//  NotesListViewController.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import UIKit

final class NotesListViewController: UITableViewController {
    
    // MARK: Properties
    var viewModel: NotesListViewModelProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        setupTableView()
        setupToolBar()
        registerObserver()
        
        viewModel?.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    // MARK: - Initialization
    init(viewModel: NotesListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.register(SimpleNoteTableViewCell.self,
                           forCellReuseIdentifier: "SimpleNoteTableViewCell")
        tableView.register(ImageNoteTableViewCell.self,
                           forCellReuseIdentifier: "ImageNoteTableViewCell")
        tableView.separatorStyle = .none
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "Add note",
                                        style: .done,
                                        target: self,
                                        action: #selector(addAction))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        setToolbarItems([spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func addAction() {
        let noteVC = NoteViewController(viewModel: NoteViewModel(note: nil))
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    @objc private func updateData() {
        viewModel?.getNotes()
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
}

// MARK: - UITableViewDataSource
extension NotesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.section.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, 
                            titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel?.section[section].items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleNoteTableViewCell", 
                                                           for: indexPath) as? SimpleNoteTableViewCell else { return UITableViewCell() }
            cell.set(note: note)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageNoteTableViewCell", 
                                                            for: indexPath) as? ImageNoteTableViewCell else { return UITableViewCell() }
            cell.set(note: note)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NotesListViewController {
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        guard let note = viewModel?.section[indexPath.section].items[indexPath.row] as? Note else { return }
        let noteVC = NoteViewController(viewModel: NoteViewModel(note: note))
        navigationController?.pushViewController(noteVC,
                                                 animated: true)
    }
}
