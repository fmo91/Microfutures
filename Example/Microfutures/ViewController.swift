//
//  ViewController.swift
//  Microfutures
//
//  Created by Fernando Ortiz on 01/27/2017.
//  Copyright (c) 2017 Fernando Ortiz. All rights reserved.
//

import UIKit
import Microfutures

struct User {
    let name: String
}

struct Post {
    let author: User
    let title: String
}

class ViewController: UIViewController {
    
    func getUser() -> Future<User> {
        return Future { completion in
            let user = User(name: "fmo91")
            completion(.success(user))
        }
    }
    
    func getPostForUser(_ user: User) -> Future<Post> {
        return Future { completion in
            let post = Post(author: user, title: "Microfutures docs")
            completion(.success(post))
        }
    }
    
    enum SomeError: Error {
        case someError
    }
    
    func callThatFails() -> Future<Void> {
        return Future { completion in
            completion(.failure(SomeError.someError))
        }
    }
    
    func getPostTitleDescription(_ post: Post) -> String {
        return "Title => \(post.title)"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser()
            .flatMap(getPostForUser)
            .map(getPostTitleDescription)
            .subscribe(
                onNext: { titleDescription in
                    print(titleDescription)
                }
            )
        
        callThatFails()
            .subscribe(
                onNext: {
                    print("It works fine!")
                },
                onError: { error in
                    switch error {
                        
                    case SomeError.someError:
                        print("Some error")
                        
                    default:
                        print("Unknown failure")
                        
                    }
                }
            )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

