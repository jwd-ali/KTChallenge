//
//  SearchCityViewController.swift
//  KTChallenge
//
//  Created by Jawad Ali on 03/05/2021.
//

import UIKit
import Combine
class SearchCityViewController: UIViewController {
    
    // MARK: - Views
    private lazy var activityIndicator = ActivityView(style: .large)
       
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = .preferredFont(forTextStyle: .headline)
        textField.textColor = .gray
        textField.placeholder = "Search cities"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchTextFieldUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 14
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.borderWidth = 1
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
          let tableView = UITableView()
        tableView.separatorStyle = .none
          tableView.backgroundColor = .white
          tableView.translatesAutoresizingMaskIntoConstraints = false
          return tableView
      }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties
    private var viewModel: SearchCityViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    private var searchString: String = ""
    
    // MARK: - Init
    init(viewModel: SearchCityViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
        setupObservers()
        
        searchTextField.addTarget(self, action: #selector(textChanges), for: .editingChanged)
        searchButton.addTarget(self, action: #selector(searchCitiesTapped), for: .touchUpInside)
    }
    
    @objc private func textChanges() {
        searchString = searchTextField.text ?? ""
    }
    
    @objc private func searchCitiesTapped() {
        viewModel.action.send(searchString)
    }
    
}
private extension SearchCityViewController {
    func setupObservers() {

        viewModel.title
            .assign(to: \.title, on: navigationItem)
            .store(in: &subscriptions)
        
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink {[weak self] loading in
                guard let self = self else {return}
                 loading ? self.view.addSubview(self.activityIndicator) : self.activityIndicator.removeFromSuperview()
            }.store(in: &subscriptions)
        
        viewModel.diffableDataSource = CitiesTableViewDiffableDataSource(tableView: tableView) {
            (tableView, indexPath, model) -> UITableViewCell? in
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier, for: indexPath) as? CityTableViewCell
            else { return UITableViewCell() }
            let viewModel = CityTableViewCellViewModel(model)
            cell.configure(with: viewModel)
           
            return cell
        }
    }
    
    func setupViews() {
        self.view.addSubview(mainStack)
        mainStack.addArrangedSubview(searchTextField)
        mainStack.addArrangedSubview(searchTextFieldUnderline)
        mainStack.addArrangedSubview(buttonStack)
        mainStack.addArrangedSubview(seperator)
  
        buttonStack.addArrangedSubview(searchButton)
        self.view.addSubview(tableView)
        
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier)
        view.backgroundColor = .white
        
        // TODO: Dark Mode Support
    }
    
    func setupConstraints() {
        
        var constraints: [NSLayoutConstraint] = []
        
        
        constraints += [
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 20),
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ]
        
        constraints += [
            searchTextFieldUnderline.heightAnchor.constraint(equalToConstant: 1)
        ]
        
        constraints += [
            searchButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        constraints += [
            seperator.heightAnchor.constraint(equalToConstant: 1),
        ]
        
        constraints +=  [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: mainStack.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
