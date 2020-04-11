//
//  SubscriptionTableViewController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import RealmSwift

class SubscriptionTableViewController: UITableViewController {
    
    let groupsService: GroupsServiceRequest = GroupsRequest(parser: SwiftyJSONParserGroups())
    var groupsList: [Results<GroupsVK>] = []
    var token: [NotificationToken] = []
    var cachedImaged = [String: UIImage]()
    
    @IBOutlet weak var searBarGroup:UISearchBar!
    
    var groupsMassive = [
        Group(name: "Party", imageGroups: UIImage(named: "party")!)
    ]
    var searching = false
    var searchAns = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsService.loadData {
            self.prepareSections()
            self.tableView.reloadData()
        }
        
    }
    
    func prepareSections () {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "Нет данных в БД")
            let groupsLetters = Array (Set (realm.objects(GroupsVK.self).compactMap{$0.name.first?.lowercased()})).sorted()
            groupsList = groupsLetters.map {realm.objects(GroupsVK.self).filter("name BEGINSWITH[cd] %s", $0)}
            token.removeAll()
            groupsList.enumerated().forEach {observeChangesGroups(section: $0.offset, results: $0.element)}
            tableView.reloadData()
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func observeChangesGroups (section: Int, results: Results<GroupsVK>) {
        
        token.append (results.observe { changes in
                guard let tableView = self.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: section)}), with: .automatic)
                    tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: section)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: section)}), with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    print(error.localizedDescription)
                }
            })
    }
    
//    func loadData () {
//        do{
//            let realm = try Realm()
//            print(realm.configuration.fileURL)
//            let groups = realm.objects(GroupsVK.self)
//            groupsList = Array( groups )
//        }catch{
//            print(error.localizedDescription)
//        }
//    }
    
    //сигуэй при выходе с контроллера, добавление элементов на другой контролллер
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        var nameGroups = [String]() //массив для перебора имен в массиве groupsMassive
        for i in groupsMassive{
            nameGroups.append(i.name)
        }
        if segue.identifier == "addGroup"  {
            // Ссылка на контроллер с которого переход
            guard let allGroupsController = segue.source as? AllGroupsTableController else { return }
            //получаем индекс ячейки с массива
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                //получаем группу по индексу
                let addGroup = allGroupsController.allGroupsMassive[indexPath.row]
                // добавляем в массив
                let nameAllGroup = addGroup.name
                if !nameGroups.contains(nameAllGroup) {
                    groupsMassive.append(addGroup)
                    print("Добавлен элемент: " + nameAllGroup)
                }
            }
            //обновляем таблицу
            tableView.reloadData()
        }
    }
    
    let queue = DispatchQueue(label: "download_url")
    private func downloadImage (for url: String, indexPath: IndexPath) {
        queue.async {
            if let image = Session.shared.getImage(url: url){
                self.cachedImaged[url] = image
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
        
    
    
    //функция удаления элементов
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let nameGroup = groupsMassive[indexPath.row]
        // Если была нажата кнопка «Удалить»
        if editingStyle == .delete {
            // Удаляем  из массива
            groupsMassive.remove(at: indexPath.row)
            print("Удален элемент: " + nameGroup.name)
            // И удаляем строку из таблицы
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    // MARK: - Table view data source
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return groupsList.count
        }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if searching{
//            return searchAns.count
//        }else{
//            return groupsMassive.count
//        }
        
        groupsList[section].count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsCell else {
            preconditionFailure("No connect GroupCell")
        }
//        if searching{
//            let subscriptionName = searchAns[indexPath.row]
//            cell.groupNameLabel.text = subscriptionName
//            for i in groupsMassive {
//                if subscriptionName == i.name{
//                    cell.groupImageView.image = i.imageGroups
//                }
//            }
//        }else {
//            let subscriptionName = groupsMassive[indexPath.row]
//            cell.groupNameLabel.text = subscriptionName.name
//            cell.groupImageView.image = subscriptionName.imageGroups
//        }
        let element = groupsList[indexPath.section][indexPath.row]
        cell.groupNameLabel.text = element.name
        let image = element.photo
        if let cached = cachedImaged[image] {
            cell.groupImageView.image = cached
        }else {
            downloadImage(for: image, indexPath: indexPath)
        }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension SubscriptionTableViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        let searchMassive = groupsMassive.map {$0.name}
        
        searchAns = searchMassive.filter({$0.prefix(searchText.count) == searchText})
        
        searching = true
        print(searchAns)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        hideKeyboard()
        searching = false
        searBarGroup.text = ""
        tableView.reloadData()
    }
    
    @objc func hideKeyboard() {
        self.searBarGroup.endEditing(true)
    }
}
