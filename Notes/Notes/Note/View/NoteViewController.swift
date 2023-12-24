//
//  NoteViewController.swift
//  Notes
//
//  Created by User on 14.12.2023.
//

import UIKit
import SnapKit

enum ColorCategory: String {
    case green, blue, yellow, red, white
    
    var color: UIColor {
        switch self {
        case .green:
            UIColor.lightGreen
        case .blue:
            UIColor.lightBlue
        case .yellow:
            UIColor.lightYellow
        case.red:
            UIColor.lightRed
        case .white:
            UIColor.white
        }
    }
}

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
        
        return view
    }()
    
    // MARK: - Properties
    var selectedColor: ColorCategory = .blue
    var viewModel: NoteViewModelProtocol? = nil
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private methods
    @objc private func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    @objc private func saveAction() {
        viewModel?.save(with: textView.text)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showColors() {
        // Create alert
        let alert = UIAlertController(title: "Category by color",
                                      message: "Choose the color of your note",
                                      preferredStyle: .actionSheet)
        // Add actions
        let redAction = makeAction(title: "Red", category: .red)
        let blueAction = makeAction(title: "Blue", category: .blue)
        let yellowAction = makeAction(title: "Yellow", category: .yellow)
        let greenAction = makeAction(title: "Green", category: .green)
        let whiteAction = makeAction(title: "Default", category: .white)
        
        alert.addActions(actions: [redAction, blueAction, yellowAction, greenAction, whiteAction])
        
        present(alert, animated: true)
    }
    
    private func makeAction(title: String, category: ColorCategory) -> UIAlertAction {
        let colorCategory = {
            return category.color
        }()
        // Get system image
        let circle = UIImage(systemName: "circle.fill")
        // Create action
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            self?.view.backgroundColor = colorCategory
            // Set case for selectedColor from UIColor
            self?.selectedColor = {
                switch colorCategory {
                case .green:
                        .green
                case .blue:
                        .blue
                case .yellow:
                        .yellow
                case .red:
                        .red
                case .white:
                        .white
                default:
                        .white
                }
            }()
        }
        // Set
        action.setValue(circle, forKey: "image")
        action.setValue(colorCategory, forKey: "imageTintColor")
        return action
    }
    
    private func configure() {
         textView.text = viewModel?.text
    }
    
    private func setupUI() {
        view.addSubview(attachmentView)
        view.addSubview(textView)
        view.backgroundColor = .white
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveAction))
    }
}
