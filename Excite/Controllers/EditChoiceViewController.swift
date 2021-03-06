//
//  EditChoiceViewController.swift
//  Excite
//
//  Created by Haasith Sanka on 8/31/20.
//  Copyright © 2020 Haasith Sanka. All rights reserved.
//

import UIKit
protocol EditChoiceViewControllerDelegate: class {
    func mcEdited( questions: [MultipleChoiceAnswer], identifier: String)
}

protocol EditChoicePersonalDetailsDelegate: class {
    func personalDetailsEdited(personal: PersonalDetails)
}

class EditChoiceViewController: UIViewController {
    var viewModel: EditChoiceViewModel?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
   
    //delegates to update profile
    weak var delegate: EditChoiceViewControllerDelegate?
    weak var personalDelegate: EditChoicePersonalDetailsDelegate?
    
    var stackView = UIStackView()
    let userTextField = UITextField()
          
    //updates appropriate personal detail item
    var currentDetail: PersonalDetailItem?
    var currentType: Details?
    
    //for date picker
    let datePicker = UIPickerView()
    var feetInches = [["1","2","3","4","5","6","7","8","9"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]]

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
    
    
    convenience init(model: EditChoiceViewModel) {
        self.init()
        self.viewModel = model
    }
    
    init() {
       super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
       super.viewDidLoad()
       setupAppropriateUI()
    }
    
    func setupAppropriateUI() {
        guard let index = viewModel?.index else { return }
        self.view.backgroundColor = .white
        self.navigationItem.title = viewModel?.questions?[index].question
        
        if let personal = viewModel?.personal {
           populate(model: personal, index: index)
        } else {
           setUpCollectionView()
            
        }
    }
    
    func populate(model: PersonalDetails, index: Int) {
        let details = Details.allCases[index]
        switch details {
        case .fullName:
            currentType = .fullName
            currentDetail = model.fullName
        case .age:
           currentType = .age
           currentDetail = model.age
        case .height:
            currentType = .height
            currentDetail = model.height
        case .gender:
            currentDetail = model.gender
            currentType = .gender
            viewModel?.selectedAnswer = model.gender.title
            viewModel?.choices = model.gender.answerChoices
        case .ethnicity:
            currentDetail = model.ethnicity
            currentType = .ethnicity
            viewModel?.selectedAnswer = model.ethnicity.title
            viewModel?.choices = model.ethnicity.answerChoices
        case .location:
            currentDetail = model.location
            currentType = .location
        case .company:
            currentDetail = model.company
            currentType = .company
        case .jobTitle:
            currentDetail = model.jobTitle
            currentType = .jobTitle
        }
        guard let currentDetail = currentDetail, let cur = currentType else { return }
        
        self.navigationItem.title = cur.rawValue

        
        if currentDetail.type == .textfield || currentDetail.type == .spinner {
            setUpTextField(model: currentDetail, title: currentDetail.title, type: cur)
        } else {
            setUpCollectionView()
        }
    }
    
    
    func setUpTextField(model: PersonalDetailItem, title: String, type: Details) {
         
        userTextField.placeholder = title
        userTextField.textColor = UIColor.black
        userTextField.layer.cornerRadius = 5.0
        userTextField.borderStyle = .roundedRect
        userTextField.backgroundColor = UIColor.white
        userTextField.autocorrectionType = UITextAutocorrectionType.yes
        userTextField.keyboardType = UIKeyboardType.default
        userTextField.returnKeyType = UIReturnKeyType.done
        userTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        userTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        userTextField.isEnabled = true
        userTextField.isUserInteractionEnabled = true
        setUpNavButtons()
    
        
        if type == .height {
            self.userTextField.delegate = self
            self.datePicker.dataSource = self
            self.datePicker.delegate = self
            userTextField.inputView = self.datePicker

            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonTapped))
            toolBar.setItems([doneButton], animated: false)
            self.userTextField.inputAccessoryView = toolBar
        }
        
        stackView.addArrangedSubview(userTextField)
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(40)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        userTextField.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
        }
    }
    
    func setUpCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(300)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.allowsSelection = true
        collectionView.register(MultipleChoiceCollectionViewCell.self, forCellWithReuseIdentifier: MultipleChoiceCollectionViewCell.reuseIdentifier)

        setUpNavButtons()
    }
    
    func setUpNavButtons() {
        let editButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(action))
        self.navigationItem.rightBarButtonItem  = editButton
    }
    
    @objc func doneButtonTapped() {
        self.userTextField.resignFirstResponder()
    }
    
    func editPersonal(personal: PersonalDetails, edited: String) -> PersonalDetails? {
        let details = currentType
        switch details {
        case .fullName:
            personal.fullName.title = edited
        case .age:
            personal.age.title = edited
        case .height:
            personal.height.title = edited
        case .gender:
           personal.gender.title = edited
        case .ethnicity:
            personal.ethnicity.title = edited
        case .location:
            personal.location.title = edited
        case .company:
            personal.company.title = edited
        case .jobTitle:
            personal.jobTitle.title = edited
        case .none:
            return nil
        }
        return personal
    }
    
    func getEditedText() -> String? {
        if let text = viewModel?.selectedAnswer {
            return text
        } else if let text = userTextField.text {
            return text
        }
        return nil
    }
    
    
    @objc func action(sender: UIBarButtonItem) {
        if let personal = viewModel?.personal, let editedText = getEditedText(), let editedPersonal = editPersonal(personal: personal,edited: editedText) {
            personalDelegate?.personalDetailsEdited(personal: editedPersonal)
        } else {
            guard let questions = viewModel?.questions, let identifier = viewModel?.identifier else {
                return
            }
            delegate?.mcEdited(questions: questions, identifier: identifier)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditChoiceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.choices?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultipleChoiceCollectionViewCell.reuseIdentifier, for: indexPath) as? MultipleChoiceCollectionViewCell, let choice = viewModel?.choices?[indexPath.row], let selectedAnswer = viewModel?.selectedAnswer {
            cell.initialize(answerChoice: choice, selectedChoice: selectedAnswer)
            if choice == selectedAnswer {
                cell.button.selectedStyling()
            } else {
                cell.button.styleButton()
            }
            cell.layer.cornerRadius = 15
            return cell
        
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let width = UIScreen.main.bounds.width/2 - (25)
           let height = CGFloat(50) // or what height you want to do
           return CGSize(width: width, height: height)
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MultipleChoiceCollectionViewCell
        guard let index = viewModel?.index, let choice = (viewModel?.choices?[indexPath.row]) else { return }
        cell?.button.selectedStyling()
        viewModel?.selectedAnswer = choice
        viewModel?.questions?[index].answer = viewModel?.selectedAnswer ?? "default"
        cell?.button.changeState()
        collectionView.reloadData()
    }
    
}

extension EditChoiceViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension EditChoiceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.feetInches[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.feetInches[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let feet = feetInches[0][pickerView.selectedRow(inComponent: 0)]
        let inches = feetInches[1][pickerView.selectedRow(inComponent: 1)]
        userTextField.text = feet + "\' " + inches + "\""
    }
}
