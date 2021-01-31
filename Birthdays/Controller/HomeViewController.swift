//
//  ViewController.swift
//  Birthdays
//
//  Created by Andre Simon on 18-01-21.
//

import UIKit
import Contacts
import BouncyLayout

class HomeViewController: UIViewController, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    private lazy var store: CNContactStore = {
        return CNContactStore()
    }()
    
    private lazy var appDelegate: AppDelegate? = {
       return UIApplication.shared.delegate as? AppDelegate
    }()

    
    var birthdays: [Birthday] = [
//        Birthday(person: "Andre Simon", date: Date()),
//        Birthday(person: "Kari", date: Date()),
//        Birthday(person: "Carla", date: Date()),
//        Birthday(person: "Mom", date: Date()),
//        Birthday(person: "Dad", date: Date()),
//        Birthday(person: "Fer Gallegos", date: Date()),
//        Birthday(person: "Seba von Bergen", date: Date()),
//        Birthday(person: "Nico Leyton", date: Date()),
//        Birthday(person: "Dani Darritchon", date: Date())
    ]
    let reuseIdentifier = "BirthdayCell"
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = BouncyLayout(style: .regular)
        layout.scrollDirection = .vertical
        
        self.title = "Birthdays"
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "BirthdayCell", bundle: .main), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
        self.collectionView.alwaysBounceVertical = true
        
        self.view.addSubview(collectionView)
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill.badge.plus"), style: .plain, target: self, action: #selector(importContacts)), UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))]
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
    }
    
    func getContactList() {
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactBirthdayKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try store.enumerateContacts(with: request, usingBlock: {
                (contact, pointer) in
                let birthday = Birthday(person: "\(contact.givenName) \(contact.familyName)", date: contact.birthday?.date ?? Date())
                self.birthdays.append(birthday)
            })
            collectionView.reloadData()
        } catch let error {
            print(error)
        }
        
    }
    
    @objc func importContacts() {
        print("import")
        let authorized = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorized {
        case .notDetermined:
            store.requestAccess(for: .contacts, completionHandler: { (status, error) in
                print(status, error ?? "")
            })
        case .authorized:
            getContactList()
        case .denied:
            print("status denied")
            
        case .restricted:
            print("status restricted")
        @unknown default:
            print("other status")
        }
    }
    
    @objc func addTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "ComposerViewController") as! ComposerViewController
        vc.birthdayDelegate = self
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.birthdays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let birthday = birthdays[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BirthdayCell
        
        cell.profileName.text = birthday.person
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3 - 5*2, height: collectionView.frame.width / 3 - 5*2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  5
    }
}

extension HomeViewController: BirthdayDelegate {
    func newBirthdayAdded(_ birthday: Birthday) {
        print("delegate")
        birthdays.append(birthday)
        collectionView.reloadData()
        
        self.appDelegate?.scheduleNotification(notificationType: "Local Notification")
        
    }
}


