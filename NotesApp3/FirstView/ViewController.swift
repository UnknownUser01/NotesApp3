
//
//  ViewController.swift
//  NotesApp3
//
//  Created by Rahul Oliver on 04/02/20.
//  Copyright © 2020 Rahul Oliver. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

struct notesData {
    var titleData: String?
    var notesData: String?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var notesTableView: UITableView!
    var arrayOfTitle: [String] = []
    var arrayOfNotes: [String] = []
    var arrayOfNotesData: [notesData] = []
    var dataInSelectedCell = notesData(titleData: "", notesData: "")
    let CELL_HEIGHT = 80
    var indexPosition: Int?
    var deleteIndex: Int?
    var container: NSPersistentContainer!
    var titles: String?
    var note: String?
    
    
    var context: NSManagedObjectContext!
    var notes: [NSManagedObject] = []
    let ENTITY_NAME = "Notes"
    let ATTRIBUTE_TITLE = "title"
    let ATTRIBUTE_NOTES = "notes"
    
    let statusBar = UIStatusBarManager.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
        navigationBar.isTranslucent = false
        // status bar text => white
        navigationBar.barStyle = .black
        // nav bar elements color => white
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.red
        }
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //tableView.separatorStyle = .none
        notesTableView.delegate = self
        notesTableView.dataSource = self
        //        tableView.emptyDataSetSource = self
        //        tableView.emptyDataSetDelegate = self
        notesTableView.tableFooterView = UIView()
        notesTableView.emptyDataSetSource = self
        notesTableView.emptyDataSetDelegate = self
        notesTableView.tableFooterView = UIView()
        if let contextVariable = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context = contextVariable
        }
        readData()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        do {
            if let note = try context.fetch(request) as? [NSManagedObject] {
                notes = note
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        restore()
        return arrayOfNotesData.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            self.deleteIndex = indexPath.row
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (handler) in
                self.titles = self.arrayOfNotesData[indexPath.row].titleData
                    self.note = self.arrayOfNotesData[indexPath.row].notesData
                    self.deleteData(title: self.titles, notes: self.note)
                    self.arrayOfNotesData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell {
            cell.titleLabel.text = arrayOfNotesData[indexPath.row].titleData
            cell.notesLabel.text = arrayOfNotesData[indexPath.row].notesData
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataInSelectedCell = arrayOfNotesData[indexPath.row]
        indexPosition = indexPath.row
        let storyboard = UIStoryboard(name: "WritingBoard", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        if let newViewController = viewController as? WritingBoardViewController {
            newViewController.titleValue = dataInSelectedCell.titleData
            newViewController.notesValue = dataInSelectedCell.notesData
            newViewController.index = indexPosition
            newViewController.delegate = self
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }
    
    @IBAction func addNotesButton(_ sender: Any) {
        //Code to call the next ViewController
        let storyboard = UIStoryboard(name: "WritingBoard", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()
        if let newViewController = vc as? WritingBoardViewController{
            newViewController.delegate = self
            indexPosition = nil
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
}

//Functions related to table and cell
extension ViewController: DoneWritingDelegate {
    
    func appendToArray(titleText: String?, notesText: String?) {
        arrayOfNotesData.append(notesData(titleData: titleText, notesData: notesText))
    }
    
    func deselectTable() {
        notesTableView.reloadData()
    }
    
    func doneWriting(title: String?, notes: String?) {
        appendTheFields(title: title, notes: notes)
    }
    
    func appendTheFields(title: String?, notes: String?) {
        if (!checkEmptyFields(title: title, notes: notes)){
            if let index = indexPosition {
                updateData(title: title, notes: notes)
                arrayOfNotesData[index].titleData = title
                arrayOfNotesData[index].notesData = notes
            } else {
                createData(title: title, notes: notes)
                appendToArray(titleText: title, notesText: notes)
            }
        }
        notesTableView.reloadData()
    }
    
    func checkEmptyFields(title: String?, notes: String?) -> Bool {
        if title == "" , notes == ""{
                return true
        }
        return false
    }
    
    func restore() {
        notesTableView.backgroundView = nil
        notesTableView.separatorStyle = .singleLine
    }
}

extension ViewController {
    
    func createData(title: String?, notes: String?) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: context)
        entity.setValue(title, forKey: ATTRIBUTE_TITLE)
        entity.setValue(notes, forKey: ATTRIBUTE_NOTES)
        do{
            try context.save()
            print("Create data sucess")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        do{
            let fetch = try context.fetch(request)
            if let fet = fetch as? [NSManagedObject] {
                for i in fet {
                    arrayOfNotesData.append(notesData(titleData: i.value(forKey: ATTRIBUTE_TITLE) as? String, notesData: i.value(forKey: ATTRIBUTE_NOTES) as? String))
                }
            }
            
            print("Read data sucess")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func updateData(title: String?, notes: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        do {
            let fetch = try context.fetch(request) as! [NSManagedObject]
            for index in fetch.indices {
                if (fetch[index].value(forKey: ATTRIBUTE_TITLE) as? String) == title, (fetch[index].value(forKey: ATTRIBUTE_NOTES) as? String) == notes {
                    fetch[index].setValue(title, forKey: ATTRIBUTE_TITLE)
                    fetch[index].setValue(notes, forKey: ATTRIBUTE_NOTES)
                    arrayOfNotesData[index].titleData = title
                    arrayOfNotesData[index].notesData = notes
                }
            }
        }
        catch {
            print(error)
        }
        do {
            try context.save()
            print("Update data sucess")
        }
        catch {
            print(error)
        }
    }
    
    func deleteData(title: String?, notes: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        do {
            if let fetch = try context.fetch(request) as? [NSManagedObject] {
                for index in fetch.indices {
                    if (fetch[index].value(forKey: ATTRIBUTE_TITLE) as? String) == title, (fetch[index].value(forKey: ATTRIBUTE_NOTES) as? String) == notes {
                        context.delete(fetch[index])
                    }
                }
            }
        }
        catch {
            print(error)
        }
        do {
            try context.save()
            print("Update data sucess")
        }
        catch {
            print(error)
        }
    }
}

//EmptyView
extension ViewController {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Welcome"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Add a new note!"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "NoteBooks")
    }
}
