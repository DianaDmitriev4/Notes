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
        
        view.delegate = self
        
        return view
    }()
    
    // MARK: - Properties
    private var imageHeight = 200
    private var imageName: String?
    private var isChange: Bool = false
    var isExist: Bool = false
    
    var selectedCategory: ColorCategory?
    
    var viewModel: NoteViewModelProtocol
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Save button
        navigationItem.rightBarButtonItem?.isHidden = true
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
        viewModel.save(with: textView.text,
                       category: selectedCategory,
                       image: attachmentView.image,
                       imageName: imageName)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        viewModel.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
    }
    
    @objc private func showSetCategoryAlert() {
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
            if self?.selectedCategory != category {
                self?.isChange = true
                self?.selectedCategory = category
            }
            self?.isHiddenSaveButton(self?.isChange ?? false)
        }
        // Set
        action.setValue(UIImage(systemName: "circle.fill"), forKey: "image")
        action.setValue(category.color, forKey: "imageTintColor")
        return action
    }
    
    private func configure() {
        textView.text = viewModel.text
        attachmentView.image = viewModel.image
        selectedCategory = viewModel.note?.category
    }
    
    private func addGesture() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        view.backgroundColor = viewModel.note?.category?.color
        
        textView.layer.borderWidth = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 1 : 0
        
        navigationController?.navigationBar.prefersLargeTitles = false
        setupConstraints()
        setupToolbar()
        setupNavigationBar()
    }
    
    private func setupConstraints() {
        attachmentView.snp.makeConstraints { make in
            let height = attachmentView.image != nil ? imageHeight : 0
            make.height.equalTo(height)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(attachmentView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
    }
    
    private func updateImageHeight() {
        attachmentView.snp.updateConstraints { make in
            make.height.equalTo(imageHeight)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveAction))
    }
    
    private func setupToolbar() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle.fill") ?? .add,
                        for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(showSetCategoryAlert), for: .touchUpInside)
        
        let circle = UIBarButtonItem(customView: button)
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        let photoButton = UIBarButtonItem(barButtonSystemItem: .camera,
                                          target: self,
                                          action: #selector(addImage))
        // Create trash button if there is a note
        if isExist {
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                              target: self,
                                              action: #selector(deleteAction))
            setToolbarItems([trashButton, spacing, photoButton, spacing, circle], animated: true)
        } else {
            setToolbarItems([spacing, photoButton, spacing, circle], animated: true)
        }
    }
    
    private func isHiddenSaveButton(_ param: Bool) {
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
        isHiddenSaveButton(!textView.text.isEmpty)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension NoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage,
              let url = info[.imageURL] as? URL else { return }
        imageName = url.lastPathComponent
        attachmentView.image = selectedImage
        updateImageHeight()
        isChange = true
        isHiddenSaveButton(isChange)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
