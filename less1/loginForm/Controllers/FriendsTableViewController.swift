//
//  FriendsTableViewController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit



class FriendsTableViewController: UITableViewController{
    
    @IBOutlet weak var searhBar: UISearchBar!
    
    var sections = [Section]()
    var searchFriend = [Search]()
    
    var friendsMassive =  [
        Friend(name: "Vlad Miller", imageFriends: UIImage(named: "Глаза1")!),
        Friend(name: "Viktor Funduk", imageFriends: UIImage(named: "1111")!),
        Friend(name: "Skala Jony", imageFriends: UIImage(named: "Jony")!),
        Friend(name: "Ben Ten", imageFriends: UIImage(named: "Ben")!),
        Friend(name: "Jessica Alba", imageFriends: UIImage(named: "Jessica")!),
        Friend(name: "Антошка Картошка", imageFriends: UIImage(named: "Cat")!),
        Friend(name: "Николай Погребняк", imageFriends: UIImage(named: "reneg")!),
        Friend(name: "Станислав Копченый", imageFriends: UIImage(named: "duck")!),
        Friend(name: "Виталий Негодяев", imageFriends: UIImage(named: "timon")!),
        Friend(name: "Hello Word", imageFriends: UIImage(named: "man")!),
        Friend(name: "Life is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Petr 1 2", imageFriends: UIImage(named: "Jessica")!),
        Friend(name: "Mife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Kife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Sife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Wife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Gife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Zife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Rife is Strange", imageFriends: UIImage(named: "wolf")!),
        Friend(name: "Oife is Strange", imageFriends: UIImage(named: "wolf")!)
    ]
    
    var searchAns = [String]()
    var nameFriend = [String]()
    var searching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TestTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "HeaderView")
        
        for i in friendsMassive{
            nameFriend.append(i.name)
        }
        //Сортировка
        let groupedDictionary = Dictionary(grouping: nameFriend, by: {String($0.prefix(1))})
        
        let keys = groupedDictionary.keys.sorted()
        

        sections = keys.map{ Section(letter: $0, names: groupedDictionary[$0]!.sorted()) }
        tableView.reloadData()
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
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
            preconditionFailure("нет связи HeaderView")
        }
        if searching {
            headerView.someLabel.text = searchFriend[section].letter
        }else {
            headerView.someLabel.text = sections[section].letter
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as? FriendsCell else {
            preconditionFailure("нет связи FriendsCell")
        }
        // Если есть буква в сеарч баре тогда
        if searching {
            let section = searchFriend[indexPath.section]
            let friend = section.names[indexPath.row]//id
            cell.friendNameLabel.text = friend// имя
            //картинка
            for i in friendsMassive{
                if i.name == friend{
                    cell.imageFriendView.image = i.imageFriends
                }
            }
        }else {
            let section = sections[indexPath.section]
            let friend = section.names[indexPath.row]//id
            cell.friendNameLabel.text = friend// имя
            //картинка
            for i in friendsMassive{
                if i.name == friend{
                    cell.imageFriendView.image = i.imageFriends
                }
            }
        }
        
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return sections[section].letter
    //    }
    //
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searching {
            return searchFriend.compactMap{$0.letter.uppercased()}
        }else {
            return sections.compactMap{$0.letter.uppercased()}
        }
        
    }
    
    
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
                for i in friendsMassive{
                    if i.name == titleFriendName{
                        destinationViewController?.collectionFriendImage = i.imageFriends
                    }
                }
            }else {
                let section = sections[indexPath.section] // id элемента
                let titleFriendName = section.names[indexPath.row]
                let destinationViewController = segue.destination as? FriendCollectionController //определение куда передаем инфу
                destinationViewController?.collectionFriendName = titleFriendName
                //картинка
                for i in friendsMassive{
                    if i.name == titleFriendName{
                        destinationViewController?.collectionFriendImage = i.imageFriends
                    }
                }
            }
            
        }
    }
    
    
}
// Поиск
extension FriendsTableViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var searchMassive = [String]()
        for i in friendsMassive{
            searchMassive.append(i.name)
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

