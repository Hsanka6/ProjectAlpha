//
//  UserTableTableViewCell.swift
//  Excite
//
//  Created by Haasith Sanka on 7/18/20.
//  Copyright © 2020 Haasith Sanka. All rights reserved.
//

import UIKit

protocol UserTableTableViewCellDelegate: class {    
    func personalDetailsEdited(personal: PersonalDetails)
    func requestEditChoiceViewController(controller: EditChoiceViewController)
    func showAlertView(alert: UIAlertController)
}


class UserTableTableViewCell: UITableViewCell {
    static var reuseIdentifier = "UserTableTableViewCell"
    var tableView = UITableView()
    var personal: PersonalDetails?
    weak var delegate: UserTableTableViewCellDelegate?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialize(personalDetails: PersonalDetails) {
        self.personal = personalDetails
        self.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.top.equalTo(5)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UserDetailTableViewCell.self, forCellReuseIdentifier: UserDetailTableViewCell.reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tableView.removeFromSuperview()
        tableView.reloadData()
    }
    
    enum Details: String, CaseIterable {
       case fullName = "Full Name"
       case age = "Age"
       case height = "Height"
       case gender = "Gender"
       case ethnicity = "Ethnicity"
       case location = "Location"
       case company = "Company"
       case jobTitle = "Job Title"
   }
   
}

extension UserTableTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailTableViewCell.reuseIdentifier) as? UserDetailTableViewCell
        cell?.selectionStyle = .none
        if let personal = personal {
            cell?.initialize(model: personal, index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let details = Details.allCases[index]
        if details.rawValue == "Full Name" || details.rawValue == "Age" {
            let alert = UIAlertController(title: "Alert", message: "\(details.rawValue) is not editable", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            delegate?.showAlertView(alert: alert)
        } else {
            let controller = EditChoiceViewController(model: EditChoiceViewModel(index: index, personal: personal))
            controller.personalDelegate = self
            delegate?.requestEditChoiceViewController(controller: controller)
        }
    }
}

extension UserTableTableViewCell: EditChoicePersonalDetailsDelegate {   
    func personalDetailsEdited(personal: PersonalDetails) {
        delegate?.personalDetailsEdited(personal: personal)
    }
}
