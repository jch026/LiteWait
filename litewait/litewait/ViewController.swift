//
//  ViewController.swift
//  litewait
//
//  Created by Yizhong Chen on 10/3/18.
//  Copyright © 2018 dumplingNinjas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var data: [String] = []
    var ref:DatabaseReference?
    var postData = [String]()
    var databaseHandle:DatabaseHandle?
    var restaurantList: Array<Restaurant> = Array()
    
    var selectedName:String = ""
    var waitName: String = ""
    var locationX: Double = 0
    var locationY: Double = 0
    var totalDistance: Double = 0
    var uid: String = ""
    var address: String = ""

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier") as! NewTableViewCell
        cell.imageContainer.image = UIImage(named: "texture")
        let restaurantObj = self.restaurantList[indexPath.row] as Restaurant
        cell.RestaurantLabel.text = restaurantObj.getName()
        if (restaurantObj.getWaitingTime() as NSString).integerValue > 200{
            cell.WaitTimeLabel.text = "200+"
        }else{
            cell.WaitTimeLabel.text = restaurantObj.getWaitingTime()
        }
        cell.distanceLabel.text = restaurantObj.getAddress()

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = restaurantList[indexPath.row].getName()
        print(restaurantList[indexPath.row].getLocationx())
        waitName = restaurantList[indexPath.row].getWaitingTime()
        locationX = restaurantList[indexPath.row].getLocationx()
        locationY = restaurantList[indexPath.row].getLocationy()
        uid = restaurantList[indexPath.row].getID()
        address = restaurantList[indexPath.row].getAddress()
        performSegue(withIdentifier: "A", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? RestaurantViewController
        {
            dvc.restaurantName = selectedName
            dvc.waitName = waitName
            dvc.locationX = locationX
            dvc.locationY = locationY
            dvc.uid = uid
            dvc.address = address
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        
        ref = Database.database().reference()
        loadRestaurants()
        
        tableView.dataSource = self
        tableView.delegate = self
        let newcellNib = UINib(nibName: "NewTableViewCell", bundle: nil)
        tableView.register(newcellNib, forCellReuseIdentifier: "ReuseIdentifier")
        
    }
    
    private func setupNavigationBarItems(){
        let image = UIImage(named: "NavBar")
        let titleImageView = UIImageView(image: image)
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func loadRestaurants(){
        ref?.child("Restaurant").observe(DataEventType.value){(snapshot) in
            self.restaurantList = []
            var postDic = snapshot.value as! [String: AnyObject]
            if(postDic != nil){
                for(id, item) in postDic {
                    let restaurant = Restaurant(id: id, dict: item as! [String:AnyObject])
                    print("1: \(restaurant.getName())")
                    self.restaurantList.append(restaurant)
                }
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CheckInternet.Connection(){
            
        }
        
        else{
            
            self.Alert(Message: "Your device is not connected to the network! Please go to settings to turn on the network!")
        }
    }
    
    func Alert (Message: String){
        let alert = UIAlertController(title: "Alert!", message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

