//
//  MyReflectionDetailViewController.swift
//  Maddori.Apple
//
//  Created by 이성호 on 2022/11/06.
//

import UIKit

import SnapKit

class MyReflectionDetailViewController: BaseViewController {
    
    // MARK: - property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setTitleFont(text: "배포 후 3차 스프린트를 돌아보세요")
        label.applyColor(to: "배포 후 3차 스프린트", with: .blue200)
        return label
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(SizeLiteral.topPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(SizeLiteral.topPadding)
            $0.leading.trailing.equalToSuperview().inset(SizeLiteral.leadingTrailingPadding)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - func
}

extension MyReflectionDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}

extension MyReflectionDetailViewController: UITableViewDelegate {
    
}
