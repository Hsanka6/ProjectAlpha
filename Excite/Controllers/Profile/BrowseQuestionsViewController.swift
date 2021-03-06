//
//  BrowseQuestionsViewController.swift
//  Excite
//
//  Created by Haasith Sanka on 8/27/20.
//  Copyright © 2020 Haasith Sanka. All rights reserved.
//

import UIKit

protocol BrowseQuestionsViewControllerDelegate: class {
    func questionsEdited(questions: [FreeResponse])
}

class BrowseQuestionsViewController: UIViewController {
    public var questions = [String]()
    public var index: Int?
    var freeResponse: [FreeResponse]?
    weak var delegate: BrowseQuestionsViewControllerDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
          
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
       
        NetworkRequester().getQuestions { cards in
            self.questions = cards.questions
            self.collectionView.reloadData()
        }
        createCollectionView()
    }
    
    init(index: Int, freeResponse: [FreeResponse]?) {
        self.index = index
        self.freeResponse = freeResponse
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        let collectionViewBackgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.frame.size
        // Start and end for left to right gradient
        gradientLayer.colors = [UIColor(hexString: "6CA0FF").cgColor, UIColor(hexString: "FF6299").cgColor]
        collectionView.backgroundView = collectionViewBackgroundView
        collectionView.backgroundView?.layer.addSublayer(gradientLayer)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.isDirectionalLockEnabled = true
        collectionView.register(QuestionCollectionViewCell.self, forCellWithReuseIdentifier: QuestionCollectionViewCell.reuseIdentifier)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
    }
}


extension BrowseQuestionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCollectionViewCell.reuseIdentifier, for: indexPath) as? QuestionCollectionViewCell {
            cell.initialize(question: questions[indexPath.row])
            cell.layer.cornerRadius = 15
            cell.delegate = self
            cell.freeResponse = freeResponse
            cell.index = index
            return cell
        
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 60
        let height = CGFloat(450)
        return CGSize(width: width, height: height)
    }
}

extension BrowseQuestionsViewController: QuestionCollectionViewCellDelegate {
    func editFreeResponse(freeResponse: [FreeResponse]) {
        delegate?.questionsEdited(questions: freeResponse)
        self.navigationController?.popViewController(animated: true)
    }
    
    func didRequestAnswerQuestionViewController(controller: AnswerQuestionViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
