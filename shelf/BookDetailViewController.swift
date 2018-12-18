//
//  BookDetailViewController.swift
//  shelf
//
//  Created by Ergin Bilgin on 20.11.2018.
//  Copyright © 2018 Ergin Bilgin. All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController {
    
    var book: Book = Book()
    @IBOutlet var bookNameLabel: UILabel!
    @IBOutlet var bookCoverImage: UIImageView!
    @IBOutlet var bookAuthorLabel: UILabel!
    
    @IBOutlet var favButton: UIButton!
    @IBOutlet var bookDescriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bookNameLabel.text = book.name!
        bookCoverImage.image = downloadImage(from: URL(string: book.cover!)!)
        bookAuthorLabel.text = "By " + book.author!
        bookDescriptionLabel.text = book.b_description!
        
        if(book.is_favourite){
            favButton.setTitle("Unfav", for: .normal)
        } else {
            favButton.setTitle("Fav", for: .normal)
        }
    }
    
    @IBAction func facButtonPressed(_ sender: Any) {
        if(book.is_favourite){
            makeFavoriteChange(isbn: book.isbn!, newValue: false)
            favButton.setTitle("Fav", for: .normal)
            book.is_favourite = false
        } else {
            makeFavoriteChange(isbn: book.isbn!, newValue: true)
            favButton.setTitle("Unfav", for: .normal)
            book.is_favourite = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadImage(from url: URL) -> UIImage {
        print("Download Started")
        let data = try? Data(contentsOf: url)
        return UIImage(data: data!)!
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "backToHomeSegue", sender: nil)
    }
    
    func makeFavoriteChange(isbn: String, newValue: Bool){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "isbn = %@", isbn)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(newValue, forKey: "is_favourite")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
}

