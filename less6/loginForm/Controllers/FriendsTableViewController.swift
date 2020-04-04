//
//  FriendsTableViewController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class FriendsTableViewController: UITableViewController{
    
    let friendService: FriendsServiceRequest = FriendRequest(parser: SwiftyJSONParserFriends())
    var friendsList: [FriendsVK] = []
    var friendName: [String] = []
    var friendImage: [UIImage] = []
    var cachedImaged = [String: UIImage]()
    
    @IBOutlet weak var searhBar: UISearchBar!
    
    var sections = [Section]()
    var searchFriend = [Search]()
    
    
    var searchAns = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TestTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        friendService.loadData {
            self.loadData()
            print(self.friendsList.count)
            var nameFriend = [String]()
            
            for i in self.friendsList{
                nameFriend.append("\(i.lastName) \(i.fisrtName)" )
            }
            //Сортировка
            let groupedDictionary = Dictionary(grouping: nameFriend, by: {String($0.prefix(1))})
            
            let keys = groupedDictionary.keys.sorted()
            
            
            self.sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
            
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    func loadData () {
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL)
            let friends = realm.objects(FriendsVK.self)
            friendsList = Array( friends )
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    private func downloadImage (for url: String, indexPath: IndexPath) {
        DispatchQueue.global().async {
            if let image = Session.shared.getImage(url: url){
                self.cachedImaged[url] = image
            }
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if searching {
            return searchFriend.count
        }else {
            return sections.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchFriend[section].names.count
        }else {
            return sections[section].names.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as? TestTableViewHeader else {
            preconditionFailure("нет связи HeaderView")}
        
        if searching {
            headerView.someLabel.text = searchFriend[section].letter
        }else {
            headerView.someLabel.text = sections[section].letter
        }
        
        headerView.layer.backgroundColor = #colorLiteral(red: 0.1813154817, green: 0.5886535645, blue: 0.9971618056, alpha: 1)
        headerView.someLabel.text = sections[section].letter
        //
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else {
            preconditionFailure("нет связи FriendsCell")
        }
        //         Если есть буква в сеарч баре тогда
        if searching {
            let section = searchFriend[indexPath.section]
            let name = section.names[indexPath.row]//id
            cell.nameLabel.text = name// имя
            //картинка
            
            
            for i in self.friendsList{
                if "\(i.lastName) \(i.fisrtName)" == name{
                    let image = i.photo
                    
                    if let cached = cachedImaged[image] {
                        cell.imageFriendView?.image = cached
                    }else {
                        downloadImage(for: image, indexPath: indexPath)
                    }
                }
            }
            
        }else {
            let section = sections[indexPath.section]
            let name = section.names[indexPath.row]//id
            cell.nameLabel.text = name// имя
            //картинка
            
            for i in self.friendsList{
                if "\(i.lastName) \(i.fisrtName)" == name{
                    let image = i.photo
                    if let cached = cachedImaged[image] {
                        cell.imageFriendView?.image = cached
                    }else {
                        downloadImage(for: image, indexPath: indexPath)
                    }
                }
            }
        }
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return sections[section].letter
    //    }
    //
    //    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        if searching {
    //            return searchFriend.compactMap{$0.letter.uppercased()}
    //        }else {
    //            return sections.compactMap{$0.letter.uppercased()}
    //        }
    //
    //    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    //функция удаления эллементов свайпом
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        var section = sections[indexPath.section]
    //        var nameFriend = section.names[indexPath.row]
    //        if editingStyle == .delete {
    //            // Delete the row from the data source
    //
    //            sections.remove(at: indexPath.section)
    //            print("Удален друг: " + String(nameFriend) + " ((((")
    //            tableView.deleteRows(at: [IndexPath(row : indexPath.row, section : indexPath.section)], with: .fade)
    //            tableView.reloadData()
    //        }
    //    }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Иницилизация при переходе с индификатором
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Show Friends",
            let indexPath = tableView.indexPathForSelectedRow {
            
            if searching {
                let section = searchFriend[indexPath.section] // id элемента
                let titleFriendName = section.names[indexPath.row]
                let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
                destinationViewController?.collectionFriendName = titleFriendName
                //картинка
                for i in friendsList{
                    if "\(i.lastName) \(i.fisrtName)" == titleFriendName{
                        destinationViewController?.collectionFriendImage = i.photoFull
                        Session.shared.userId = i.id
                    }
                }
            }else {
                let section = sections[indexPath.section] // id элемента
                let titleFriendName = section.names[indexPath.row]
                let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
                destinationViewController?.collectionFriendName = titleFriendName
                //картинка
                for i in friendsList{
                    if "\(i.lastName) \(i.fisrtName)" == titleFriendName{
                        destinationViewController?.collectionFriendImage = i.photoFull
                        Session.shared.userId = i.id
                    }
                }
            }
            
            //            let section = friendsList[indexPath.row]
            //            let firstFriendName = section.fisrtName
            //            let lasFriendName = section.lastName
            //            let image = section.photoFull
            //            let id = section.id
            //            let destinationViewController = segue.destination as? FriendCollectionController
            //            destinationViewController?.collectionFriendName = "\(firstFriendName) \(lasFriendName)"
            //            destinationViewController?.collectionFriendImage = image
            //            Session.shared.userId = id
        }
    }
    
    
}
// Поиск
extension FriendsTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var searchMassive = [String]()
        for i in friendsList{
            searchMassive.append("\(i.lastName) \(i.fisrtName)")
        }
        //Поиск
        searchAns = searchMassive.filter({$0.contains(searchText)})
        //Сортировка под новую структуру
        let groupedDictionary = Dictionary(grouping: searchAns, by: {String($0.prefix(1))})
        let keys = groupedDictionary.keys.sorted()
        searchFriend = keys.map{ Search(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        
        
        searching = true
        print(searchAns)
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        hideKeyboard()
        searching = false
        searchBar.text = ""
        tableView.reloadData()
        
    }
    //Закрыть клавиатуру
    @objc func hideKeyboard() {
        self.searhBar.endEditing(true)
    }
    
    
    
    
    
}
