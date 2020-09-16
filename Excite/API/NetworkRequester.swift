//
//  NetworkRequester.swift
//  Excite
//
//  Created by Haasith Sanka on 7/16/20.
//  Copyright © 2020 Haasith Sanka. All rights reserved.
//

import Alamofire
import Firebase
import FirebaseFirestoreSwift

protocol NetworkRequesterProtocol {
    //func getQuestion(completion: @escaping (Swift.Result<Question, Error>) -> Void)
    //func getProfile(completion: @escaping (Swift.Result<Profile, Error>) -> Void)
}

class NetworkRequesterMock: NetworkRequesterProtocol {
//    func getQuestion(completion: @escaping (Result<Question, Error>) -> Void) {
//        let oneSecond = DispatchTime.now() + 1
//        let mockResponsePath = Bundle.main.path(forResource: "Question", ofType: "json")
//        do {
//          let data = try Data(contentsOf: URL(fileURLWithPath: mockResponsePath!))
//          let response = try JSONDecoder().decode(Question.self, from: data)
//            DispatchQueue.main.asyncAfter(deadline: oneSecond) {
//                completion(.success(response))
//            }
//          } catch {
//            print(error)
//        }
//    }
//    func getProfile(completion: @escaping (Swift.Result<Profile, Error>) -> Void) {
//        let oneSecond = DispatchTime.now() + 1
//        let mockResponsePath = Bundle.main.path(forResource: "Profile", ofType: "json")
//        do {
//          let data = try Data(contentsOf: URL(fileURLWithPath: mockResponsePath!))
//          let response = try JSONDecoder().decode(Profile.self, from: data)
//            DispatchQueue.main.asyncAfter(deadline: oneSecond) {
//                completion(.success(response))
//            }
//          } catch {
//            print(error)
//        }
//    }

    
    func getUser(completion: @escaping(User) -> Void) {
        let database = Firestore.firestore()
        database.collection("Users").document("test").getDocument { (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user)
                } else {
                    print("Document doesn't exist")
                }
            case .failure(let error):
                print("Error decoding something here \(error)")
            }
        }
    }
    
    
    
    
    func getQuestions(completion: @escaping(QuestionCards) -> Void) {
        let database = Firestore.firestore()
        database.collection("FreeResponse").document("ProfileQuestions").getDocument { (document, error) in
            let result = Result {
                try document?.data(as: QuestionCards.self)
            }
            switch result {
            case .success(let questions):
                if let questions = questions {
                    completion(questions)
                } else {
                    print("Document doesn't exist")
                }
            case .failure(let error):
                print("Error decoding something here \(error)")
            }
        }
    }
    
}