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
    var bookList: [UIImage] = []
    var books: [Book] = []
    
    override func viewDidLoad() {
        print("call - viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let api = APIWrapper()
        //self.deleteData2()
        //api.bookWithISBN(isbn: "9780984782857");
        //createData()
        bookList = retrieveData()
        collectionView.reloadSections(IndexSet(integer: 0))
        //print(book.authors[0])
        
        
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
        
        let book = bookList[indexPath.row]
        
        cell.displayContent(image: bookList[indexPath.row])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*I am able to present the view controller but no data is shown*/
        
        let book = bookList[indexPath.row]
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "detto")
        self.present(newViewController, animated: true, completion: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func createData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        for i in 1...5 {
            
            let book = NSManagedObject(entity: bookEntity, insertInto: managedContext)
            book.setValue("Book \(i)", forKeyPath: "name")
            book.setValue("Lorem ipsum \(i)", forKey: "b_description")
            book.setValue(false, forKey: "is_favourite")
            book.setValue("Author \(i)", forKey: "author")
            book.setValue("ISBN \(i)", forKey: "isbn")
            book.setValue(360, forKey: "pages")
        }
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    
    
    
    func retrieveData() -> [UIImage]{
        print("call - retrieveData()")
        var images: [UIImage] = []
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //We need to create a context from this container
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "name = %@", "Book")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
                print(data.value(forKey: "cover") as! String)
                let downloadCoverURL = data.value(forKey: "cover") as! String
                if let url = URL(string: downloadCoverURL) {
                    downloadImage(from: url)
                }
                //images.append(UIImage(named: "b2")!)
                //managedContext.delete(data)
            }
            
        } catch {
            
            print("Failed")
        }
        return images
    }
    
    func updateData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Book 1")
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "name")
            objectUpdate.setValue("newDescription", forKey: "b_description")
            objectUpdate.setValue(true, forKey: "isFavourite")
            objectUpdate.setValue("newAuthor", forKey: "author")
            objectUpdate.setValue("newISBN", forKey: "isbn")
            objectUpdate.setValue(150, forKey: "pages")
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
    
    func deleteData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "name = %@", "Book 3")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
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
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.bookList.append(UIImage(data: data)!)
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }


}




