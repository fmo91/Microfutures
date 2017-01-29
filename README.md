# Microfutures

[![CI Status](http://img.shields.io/travis/Fernando Ortiz/Microfutures.svg?style=flat)](https://travis-ci.org/Fernando Ortiz/Microfutures)
[![Version](https://img.shields.io/cocoapods/v/Microfutures.svg?style=flat)](http://cocoapods.org/pods/Microfutures)
[![License](https://img.shields.io/cocoapods/l/Microfutures.svg?style=flat)](http://cocoapods.org/pods/Microfutures)
[![Platform](https://img.shields.io/cocoapods/p/Microfutures.svg?style=flat)](http://cocoapods.org/pods/Microfutures)

## Introduction
Microfutures is a very small library (60 LOCs) that implements a simple Futures/Promises flow. It also has a similar public interface to [RxSwift](https://github.com/ReactiveX/RxSwift). 

## What is a future?
A future is a representation of a value that hasn't been already generated. The best use case of Futures is to simplify an asynchronous flow. Instead of writing nested callbacks, you can chain futures, turning that awful callback hell into a beautiful functional pipeline.

## In a glance

Microfutures lets you turn from this:

```swift
getUser(withID: 3) { user, error in
	if let error = error {
		print("An error ocurred") 
    } else if let user = user {
    	self.getPosts(forUserID: user.id) { posts, error in
        	if let error = error {
            	print("An error ocurred")
            } else if let posts = posts {
            	if let firstPost = posts.first {
                	self.getComments(forPostID: firstPost.id) { error, comments in
                    	if let error = error {
			            	print("An error ocurred")
                        } else if let comments = comments {
                        	print("Comments count: \(comments.count)")
                        }
                    }
                }
            }
        }
    }
}
```

(And I am not exaggerating here, this is a pretty common scenario, and everyone is guilty for writing something like this at least once.)

To this:

```swift
getUser(withID: 3)
	.flatMap(getPosts)
    .map { posts in return posts.first?.id }
    .flatMap(getComments)
    .map { comments in return comments.count }
    .subscribe (
    	onNext: { commentsCount in
        	print("Comments count: \(commentsCount)")
        }, 
        onError: { error in
        	print("An error ocurred.")
        }
    )
```

Much cleaner.

## Creating a future
Creating a future couldn't be simpler.

Lets compare how you write a callback based async function vs a future based async function.

```swift
// Callback based func:
func getUser(withID id: Int, completion: (Error?, User?) -> Void) {
	APIClient
    	// This api client also works using callbacks
	    .get("https://somecoolapi.com/users/\(id)") { error, json in 
        	if let error = error {
            	completion(error, nil)
                return
            } else {
            	guard let json = json else {
                	completion(NetworkingError.emptyResponse, nil)
                    return
                }
                guard let user = User(json: json) else {
                	completion(NetworkingError.invalidReponse, nil)
                    return
                }
                completion(nil, user)
            }
        }
} 
```

Here is the future based async function:

```swift
func getUser(withID id: Int) -> Future<User> {
	return Future { completion in
    	APIClient
        	// Imagine that this api client still uses a callback based approach.
        	.get("https://somecoolapi.com/users/\(id)") { error, json in
            	if let error = error {
                    completion(.failure(error))
                    return
                } else {
                    guard let json = json else {
                        completion(.failure(NetworkingError.emptyResponse))
                        return
                    }
                    guard let user = User(json: json) else {
                        completion(.failure(NetworkingError.invalidReponse))
                        return
                    }
                    completion(.success(user))
                }
			}
    }
}
```

Yes, it's exactly the same. But that's because our API Client still uses a callback based approach.

One of the strong points of using a Futures based approach is that you can use functional tools. Compare the previous snippet with this:

```swift
func getUser(withID id: Int) -> Future<User> {
	return APIClient
    	.get("https://somecoolapi.com/users/\(id)")
        .map { json in
            guard let user = User(json: json) else {
                throw NetworkingError.invalidReponse
            }
            completion(.success(user))
        }
}
```

As I will explain later, the `map` function transforms the `Future` value to another value. In this case, `map` transforms the json value to a User object.

## Transforming Future's value using map
`map` transforms the output of a Future in another value.

For example:

```swift
getAlbum(withID: 3)
	.map { album in
    	return album.title
    }
    .map { albumTitle in
    	return "THe album title is \(albumTitle)"
    }
    // ...
```

An important thing about `map` is that it won't be executed if the future contains an error.

`map` can also throw an error if it's necessary:

```swift
getUser(withID: 3)
	.map { user in
    	guard let mobile = user.mobilePhone else {
        	throw UserError.noMobileNumber
        }
        return mobile
    }
```

## Chaining Futures using flatMap

Sometimes you want to perform an async function after another async function. This often results in a callback hell.
Futures has a solution for that, and it's using `flatMap`

`flatMap` receives a function that transforms the output value of the future and returns another future.

For example:

```swift

func getPosts(forUserID userID: Int) -> Future<[Post]> {
	return APIClient
    	.get("https://somecoolapi.com/posts?userID=\(userID)")
        .map { json in
        	guard let jsonArray = json as? [JSON] else {
            	throw NetworkingError.invalidReponse
            }
        	return jsonArray.map(Post.init)
        }
}

getUser(withID: 3)
	.flatMap { user in
    	return getPosts(forUserID: user.id)
    }
    
// Or doing this
getUser(withID: 3)
	.map { user in return user.id }
	.flatMap (getPosts)
```

## Resolving Futures

The last step is subscribing to the `Future`. It's achieved by using the `subscribe` method.

For example:

```swift
getUser(withID: 3)	
	.map { user in return user.id }
	.flatMap (getPosts)
	.subscribe( 
    	onNext: { posts in
			// Do something with posts...
        },
        onError: { error in
        	// Handle this error.
        }
    )
```

Subscribe receives two functions, one for the happy path, and another for the wrong case.

`onNext` is a function that receives the `Future` value and performs something with that value.

`onError` is a function that receives an error and handles it.

## Similarity with RxSwift

`Future` methods names has been chosen following RxSwift names. `map`, `flatMap`, and `subscribe` are names that RxSwift uses, and this library can be used as an introduction for somebody to RxSwift terms.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

Microfutures is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Microfutures"
```

Or you can just copy and paste `Microfutures.swift` into your project.

## Author

Fernando Ortiz, ortizfernandomartin@gmail.com

## License

Microfutures is available under the MIT license. See the LICENSE file for more info.
