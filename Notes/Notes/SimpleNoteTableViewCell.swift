//
//  SimpleNoteTableViewCell.swift
//  Notes
//
//  Created by User on 13.12.2023.
//

import UIKit
import SnapKit

final class SimpleNoteTableViewCell: UITableViewCell {
    
    //MARK: - GUI variables
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightYellow
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title label text"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, 
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func set(note: Note) {
        titleLabel.text = note.title
        containerView.backgroundColor = note.getCategory()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}
