//
//  FirstViewController.swift
//  shelf
//
//  Created by Ergin Bilgin on 20.11.2018.
//  Copyright © 2018 Ergin Bilgin. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    var bookList: [Book] = []
    var books: [Book] = []
    
    override func viewDidLoad() {
        print("call - viewDidLoad")
        super.viewDidLoad()
        
        bookList = retrieveData()
        collectionView.reloadSections(IndexSet(integer: 0))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bookList = retrieveData()
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! CollectionViewCell
        
        let imageURL = URL(string: bookList[indexPath.row].cover!)!
        
        cell.displayContent(image: downloadImage(from: imageURL))
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let book = bookList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "detto") as! BookDetailViewController
        newViewController.book = book
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveData() -> [Book]{
        print("call - retrieveData()")
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        var bookList: [Book] = []
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                bookList.append(data as! Book)
                print("Got data")
            }
            
        } catch {
            
            print("Failed")
        }
        return bookList
    }
    
    func deleteData2() {
        
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage {
        print("Download Started")
        let data = try? Data(contentsOf: url)
        return UIImage(data: data!)!
    }
    
}




