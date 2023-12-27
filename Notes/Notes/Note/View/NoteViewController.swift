//
//  NoteViewController.swift
//  Notes
//
//  Created by User on 14.12.2023.
//

import UIKit
import SnapKit

final class NoteViewController: UIViewController {
    
    // MARK: - GUI Variables
    private lazy var attachmentView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        
//        view.delegate = self
        
        return view
    }()
    
    // MARK: - Properties
    private var isChange: Bool = false
    
    var selectedCategory: ColorCategory? {
        didSet {
            isChange = true
        }
    }
    
    var viewModel: NoteViewModelProtocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configText()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem?.isHidden = true
        changeTrashButton()
    }
    
    // MARK: - Initialization
    init(viewModel: NoteViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    @objc private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    @objc private func saveAction() {
        viewModel.save(with: textView.text, category: selectedCategory ?? .white)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        viewModel.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showColors() {
        let alert = UIAlertController(title: "Category by color",
                                      message: "Choose the color of your note",
                                      preferredStyle: .actionSheet)
     
        alert.addActions(actions: ColorCategory.allCases.map({ makeAction(category: $0) }))
        
        present(alert, animated: true)
    }
    
    private func makeAction(category: ColorCategory) -> UIAlertAction {
        // Create action
        let action = UIAlertAction(title: category.title, style: .default) { [weak self] _ in
            self?.view.backgroundColor = category.color
            self?.selectedCategory = category
            self?.hidingSaveButton(param: self?.isChange ?? false)
        }
        // Set
        action.setValue(UIImage(systemName: "circle.fill"), forKey: "image")
        action.setValue(category.color, forKey: "imageTintColor")
        return action
    }
    
    private func configText() {
        textView.text = viewModel.text
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        view.backgroundColor = viewModel.note?.category?.color
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        textView.layer.borderWidth = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0
        
        setupConstraints()
        setImageHeight()
        setupBars()
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func changeTrashButton() {
        let trashButton = toolbarItems?.first
        if textView.layer.borderWidth == 1 {
            trashButton?.isHidden = true
        } else {
            trashButton?.isHidden = false
        }
    }
    
    private func setImageHeight() {
        let height = attachmentView.image != nil ? 200 : 0
        
        attachmentView.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    private func setupBars() {
        let imageCircle = UIImage(systemName: "circle.fill") ?? .add
        
        let button = UIButton(type: .custom)
        button.setImage(imageCircle, for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(showColors), for: .touchUpInside)
        
        let circle = UIBarButtonItem(customView: button)
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteAction))
        setToolbarItems([trashButton, spacing, circle],
                        animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveAction))
    }
    
    private func hidingSaveButton(param: Bool) {
        if param {
            navigationItem.rightBarButtonItem?.isHidden = false
        } else {
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
}


// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        hidingSaveButton(param: !textView.text.isEmpty)
        
//        if !textView.text.isEmpty || isChange {
//            navigationItem.rightBarButtonItem?.isHidden = false
//        } else {
//            navigationItem.rightBarButtonItem?.isHidden = true
//        }
    }
}
