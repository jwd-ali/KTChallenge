//
//  CityTableViewCell.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import Combine
import UIKit

class CityTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: - Properties
    private lazy var stateCountryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Properties
    private var subscriptions: [AnyCancellable] = []
    private var viewModel: CityTableViewCellViewModelType?
    
    // MARK: - Configuration
    func configure(with viewModel: Any) {
        guard let `viewModel` = viewModel as? CityTableViewCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews(viewModel)
    }
}

// MARK: - View setup
private extension CityTableViewCell {
    func setupViews() {
        stateCountryStack.addArrangedSubview(stateLabel)
        stateCountryStack.addArrangedSubview(countryLabel)
        
        mainStack.addArrangedSubview(cityLabel)
        mainStack.addArrangedSubview(stateCountryStack)
        mainStack.addArrangedSubview(seperator)
        
        contentView.addSubview(mainStack)
    }
    
    func setupConstraints() {
        
        var constraints = [NSLayoutConstraint]()
        
        constraints += [
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 20),
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            seperator.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Binding
private extension CityTableViewCell {
    func bindViews(_ viewModel: CityTableViewCellViewModelType) {
        self.subscriptions = [
            viewModel.cityName.assign(to: \.text, on: cityLabel),
            viewModel.countryName.assign(to: \.text, on: countryLabel),
            viewModel.stateName.assign(to: \.text, on: stateLabel),
        ]
    }
}
