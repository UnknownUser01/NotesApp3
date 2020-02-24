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

struct NotesData {
    var titleData: String?
    var notesData: String?
}

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var notesTableView: UITableView!
    var arrayOfTitle: [String] = []
    var arrayOfNotes: [String] = []
    var arrayOfNotesData: [NotesData] = []
    var dataInSelectedCell = NotesData(titleData: "", notesData: "")
    let cellHEIGHT = 80
    var indexPosition: Int?
    var deleteIndex: Int?
    var container: NSPersistentContainer!
    var titles: String?
    var note: String?
    var context: NSManagedObjectContext!
    var notes: [NSManagedObject] = []
    let statusBar = UIStatusBarManager.self
    var delegate: LogOutDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle()
        setStatusBarStyle()
        setDefaultTableSettings()
        setContextVariable()
        readData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        restore()
        return arrayOfNotesData.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteIndex = indexPath.row
            let alert = UIAlertController(title: Strings.alert, message: Strings.areYouSure, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Strings.delete, style: .default, handler: { _ in
                self.titles = self.arrayOfNotesData[indexPath.row].titleData
                    self.note = self.arrayOfNotesData[indexPath.row].notesData
                    self.deleteData(title: self.titles, notes: self.note)
                    self.arrayOfNotesData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }))
            alert.addAction(UIAlertAction(title: Strings.cancel, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let cell = Bundle.main.loadNibNamed(Strings.tableViewCell, owner: self, options: nil)?.first as? TableViewCell {
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
        let storyboard = UIStoryboard(name: Strings.writingBoard, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        if let newViewController = viewController as? WritingBoardViewController {
            newViewController.titleValue = dataInSelectedCell.titleData
            newViewController.notesValue = dataInSelectedCell.notesData
            newViewController.delegate = self
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
    }

    @IBAction func addNotesButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: Strings.writingBoard, bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        if let newViewController = viewController as? WritingBoardViewController {
            newViewController.delegate = self
            indexPosition = nil
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainViewController {
    func setNavigationBarStyle() {
        navigationBar.barTintColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
        navigationBar.isTranslucent = false
        // status bar text => white
        navigationBar.barStyle = .black
        // nav bar elements color => white
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    func setStatusBarStyle() {
        if #available(iOS 13.0, *) {
            let windowKey = UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .map({ $0 as? UIWindowScene })
            .compactMap({ $0 })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
            let statusBar = UIView(frame: ((windowKey?.windowScene?.statusBarManager?.statusBarFrame))!)
            statusBar.backgroundColor = UIColor(red: 43/255.0, green: 79/255.0, blue: 133/255.0, alpha: 1.0)
            view.addSubview(statusBar)
        }
    }

    func setDefaultTableSettings() {
        notesTableView.separatorStyle = .none
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.tableFooterView = UIView()
        notesTableView.emptyDataSetSource = self
        notesTableView.emptyDataSetDelegate = self
        notesTableView.tableFooterView = UIView()
    }

    func setContextVariable() {
        if let contextVariable = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context = contextVariable
        }
    }
}

extension MainViewController: DoneWritingDelegate {
    func appendToArray(titleText: String?, notesText: String?) {
        arrayOfNotesData.append(NotesData(titleData: titleText, notesData: notesText))
    }

    func deselectTable() {
        notesTableView.reloadData()
    }

    func doneWriting(title: String?, notes: String?) {
        canAppendTheFields(title: title, notes: notes)
    }

    func canAppendTheFields(title: String?, notes: String?) {
        if !checkEmptyFields(title: title, notes: notes) {
            appendTheFields(title: title, notes: notes)
        }
        notesTableView.reloadData()
    }

    func appendTheFields(title: String?, notes: String?) {
        if let index = indexPosition {
            updateData(title: title, notes: notes)
            arrayOfNotesData[index].titleData = title
            arrayOfNotesData[index].notesData = notes
        } else {
            createData(title: title, notes: notes)
            appendToArray(titleText: title, notesText: notes)
        }
    }

    func checkEmptyFields(title: String?, notes: String?) -> Bool {
        if title == "", notes == "" {
                return true
        }
        return false
    }

    func restore() {
        notesTableView.backgroundView = nil
        notesTableView.separatorStyle = .singleLine
    }
}

extension MainViewController {
    func createData(title: String?, notes: String?) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: Strings.entityName, into: context)
        entity.setValue(title, forKey: Strings.attributeTitle)
        entity.setValue(notes, forKey: Strings.attributeNotes)
        do {
            try context.save()
            print(Strings.createDataSucess)
        } catch {
            print(error.localizedDescription)
        }
    }

    func readData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Strings.entityName)
        do {
            let fetch = try context.fetch(request)
            if let fet = fetch as? [NSManagedObject] {
                for index in fet {
                    arrayOfNotesData.append(NotesData(titleData: index.value(forKey: Strings.attributeTitle) as? String, notesData: index.value(forKey: Strings.attributeNotes) as? String))
                }
            }
            print(Strings.readDataSucess)
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateData(title: String?, notes: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Strings.entityName)
        do {
            if let fetchRequest = try context.fetch(request) as? [NSManagedObject] {
                let fetch = fetchRequest
                checkAndUpdateData(fetch: fetch, title: title, notes: notes)
            }
            try context.save()
            print(Strings.updateDataSucess)
        } catch {
            print(error)
        }
    }

    func checkAndUpdateData(fetch: [NSManagedObject], title: String?, notes: String?) {
        for index in fetch.indices {
            if (fetch[index].value(forKey: Strings.attributeTitle) as? String) == title, (fetch[index].value(forKey: Strings.attributeNotes) as? String) == notes {
                fetch[index].setValue(title, forKey: Strings.attributeTitle)
                fetch[index].setValue(notes, forKey: Strings.attributeNotes)
                arrayOfNotesData[index].titleData = title
                arrayOfNotesData[index].notesData = notes
            }
        }
    }

    func deleteData(title: String?, notes: String?) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Strings.entityName)
        do {
            if let fetch = try context.fetch(request) as? [NSManagedObject] {
                checkAndDeleteData(fetch: fetch, title: title, notes: notes)
                try context.save()
                print(Strings.deleteDataSucess)
            }
        } catch {
            print(error)
        }
    }

    func checkAndDeleteData(fetch: [NSManagedObject], title: String?, notes: String?) {
        for index in fetch.indices {
            if (fetch[index].value(forKey: Strings.attributeTitle) as? String) == title, (fetch[index].value(forKey: Strings.attributeNotes) as? String) == notes {
                context.delete(fetch[index])
            }
        }
    }
}

extension MainViewController {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = Strings.welcome
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = Strings.addANewNote
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: Strings.noteBooks)
    }
}
