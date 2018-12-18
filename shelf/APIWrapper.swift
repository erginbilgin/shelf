//
//  APIWrapper.swift
//  shelf
//
//  Created by Ergin Bilgin on 20.11.2018.
//  Copyright © 2018 Ergin Bilgin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Unbox


class APIWrapper{
    
    
    init(){
        //TODO: Implement
    }
    
    func bookWithISBN(isbn: String){
        apiRequest(isbn: isbn) { (d_book) in
            self.saveToCore(bookToSave: d_book, isbn: isbn)
        }
    }
    
    
    
    func apiRequest(isbn: String, completion:@escaping (_ book:UnboxableBook)-> Void){
        // Helpers
        let sharedSession = URLSession.shared
        
        //let apiKey = "AIzaSyD6o0FSkKrZJXVVRqfW6c0770I6PKPUl6Y"
        
        if let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)") {
            // Create Data Task
            let dataTask = sharedSession.dataTask(with: url, completionHandler: { (data, response, error) in
                if let requestError = error {
                    print("Unable to Fetch Book Data")
                    print("\(requestError), \(requestError.localizedDescription)")
                    
                } else if let bookData = data {
                    
                    completion(self.processBookData(bookData)!)
                    
                }
            })
            
            dataTask.resume()
        }
    }
    
    
    func saveToCore(bookToSave: UnboxableBook, isbn: String){
        DispatchQueue.main.async {
            print("call - saveToCore")
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Now let’s create an entity and new user records.
            let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
            
            //final, we need to add some data to our newly created record for each keys using
            //here adding 5 data with loop
            
            let book = NSManagedObject(entity: bookEntity, insertInto: managedContext)
            book.setValue(bookToSave.name, forKeyPath: "name")
            book.setValue(bookToSave.b_desctiption, forKey: "b_description")
            book.setValue(false, forKey: "is_favourite")
            book.setValue(bookToSave.authors[0], forKey: "author")
            book.setValue(isbn, forKey: "isbn")
            book.setValue(bookToSave.pages, forKey: "pages")
            book.setValue(bookToSave.cover, forKey: "cover")
            
            //Now we have set all the values. The next step is to save them inside the Core Data
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    private func processBookData(_ data: Data) -> UnboxableBook?{
        if let dataAsString = String(data: data, encoding: String.Encoding.utf8) {
            //print(dataAsString)
        }
        do {
            let bk: UnboxableGoogleBooksAPIResponse = try unbox(data: data)
            print(bk.books[0].authors[0])
            print(bk.books[0].b_desctiption)
            print(bk.books[0].cover)
            print(bk.books[0].name)
            print(bk.books[0].pages)
            
            return bk.books[0]
            
            
        } catch {
            print("Something happened")
            return nil
        }
        
    }
    
}

struct UnboxableGoogleBooksAPIResponse{
    let books: [UnboxableBook]
}

extension UnboxableGoogleBooksAPIResponse: Unboxable{
    init(unboxer: Unboxer) throws {
        self.books = try unboxer.unbox(key: "items")
    }
}


struct UnboxableBook{
    let authors: [String]
    let b_desctiption: String
    let cover: String
    let name: String
    let pages: Int
}

extension UnboxableBook: Unboxable{
    init(unboxer: Unboxer) throws {
        self.authors = try unboxer.unbox(keyPath: "volumeInfo.authors")
        self.b_desctiption = try unboxer.unbox(keyPath: "volumeInfo.description")
        self.cover = try unboxer.unbox(keyPath: "volumeInfo.imageLinks.thumbnail")
        self.name = try unboxer.unbox(keyPath: "volumeInfo.title")
        self.pages = try unboxer.unbox(keyPath: "volumeInfo.pageCount")
    }
}

