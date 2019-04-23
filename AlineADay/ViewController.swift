//
//  ViewController.swift
//  AlineADay
//
//  Created by developer on 29/03/19.
//  Copyright © 2019 AlineADay. All rights reserved.
//

import UIKit


protocol addNewCategoryProtocol: class {
    func doneContinue()
    func doneDateSelected(getDate:String)
    
    
}
class ViewController: UIViewController,addNewCategoryProtocol {
    
    func doneDateSelected(getDate: String) {
        
        currentYear = getDate
        refresh()
        navigationBar()
        
        checkNoRecordView()
    }
    
    func doneContinue() {
        
        
        refresh()
        
        checkNoRecordView()
    }
    

    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var viwNoRecord: UIView!
    var CurrentSelectedIndex:Int = -1
    let aryMonth:NSArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var viwEdit: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    
    var aryData:NSMutableArray = NSMutableArray()
    
    var currentYear = "2019"
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.title = "Line A Day"
        tbl.tableFooterView = UIView()
        tbl.estimatedRowHeight = 44.0
        tbl.rowHeight = UITableView.automaticDimension
        
        viwEdit.layer.cornerRadius = 30
        btnEdit.clipsToBounds = true
        btnEdit.layer.cornerRadius = 30
        navigationBar()
    }
    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if(CurrentSelectedIndex == -1)
        {
        let getToday = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd "
        let theDate = dateFormatter.string(from: getToday)
        
        dateFormatter.dateFormat = "MM"
        let theTodayDate = dateFormatter.string(from: getToday)
        let index:Int = Int(theTodayDate) ?? 1
        CurrentSelectedIndex = index - 1
            
        dateFormatter.dateFormat = "YYYY"
        let theYear = dateFormatter.string(from: getToday)
            currentYear = theYear
        
        let currentIndex = IndexPath(row: CurrentSelectedIndex, section: 0)
        self.monthCollectionView.scrollToItem(at: currentIndex, at: .left, animated: true)
        self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory(bymonth: theDate)
       //print(getTodayaryData)
        self.tbl.reloadData()
        }else
        {
            var getMonth = ""
            if(CurrentSelectedIndex+1 > 9)
            {
                getMonth = String(CurrentSelectedIndex+1)
            }else
            {
                getMonth = "0" + String(CurrentSelectedIndex+1)
            }
            
            
            
            
            let createStartingDate:String = "\(currentYear)-\(getMonth)-30"
            
           // print("createStartingDate",createStartingDate)
            
            
            
            let currentIndex = IndexPath(row: CurrentSelectedIndex, section: 0)
            self.monthCollectionView.scrollToItem(at: currentIndex, at: .left, animated: true)
            self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory(bymonth: createStartingDate)
            //print(getTodayaryData)
            self.tbl.reloadData()
        }
        
       checkNoRecordView()
        
        
        navigationBar()
    }
    
    
    func navigationBar()
    {
        let testUIBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(self.click_Setting))
        testUIBarButtonItem.title = currentYear
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        
        
    }
    
    
    func checkNoRecordView()
    {
        if(aryData.count > 0)
        {
            self.viwNoRecord.isHidden = true
        }else
        {
            self.viwNoRecord.isHidden = false
        }
    }
    
    func refresh()
    {
        
        if(CurrentSelectedIndex == -1)
        {
            let getToday = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let theDate = dateFormatter.string(from: getToday)
            
            self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory(bymonth: theDate)
            //print(getTodayaryData)
            self.tbl.reloadData()
        }else
        {
            var getMonth = ""
            if(CurrentSelectedIndex+1 > 9)
            {
                getMonth = String(CurrentSelectedIndex+1)
            }else
            {
                getMonth = "0" + String(CurrentSelectedIndex+1)
            }
            
            
            
            
            let createStartingDate:String = "\(currentYear)-\(getMonth)-30"
            
            // print("createStartingDate",createStartingDate)
            
            
            
            let currentIndex = IndexPath(row: CurrentSelectedIndex, section: 0)
            self.monthCollectionView.scrollToItem(at: currentIndex, at: .left, animated: true)
            self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllCategory(bymonth: createStartingDate)
            //print(getTodayaryData)
            self.tbl.reloadData()
        }
    }
    
    
    @IBAction func click_Setting(sender: UIButton)
    {
        
        
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:SelectDateViewController = mainStory.instantiateViewController(withIdentifier: "SelectDateViewController") as! SelectDateViewController
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        viewController.selectedYear = currentYear
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func click_EditCell(sender: UIButton)
    {
        let getObje = self.aryData.object(at: sender.tag) as! NSDictionary
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:addNote = mainStory.instantiateViewController(withIdentifier: "addNote") as! addNote
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        viewController.isEdit = true
        viewController.getObj = getObje
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func click_Add(sender: UIButton)
    {
        
        
        let mainStory : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController:addNote = mainStory.instantiateViewController(withIdentifier: "addNote") as! addNote
        
        viewController.modalPresentationStyle = .overFullScreen
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func getStartMonthDate(getmonth:String)->String
    {
        
        
        switch getmonth {
            
        case "01":
           return "31"
        case "02":
            return "28"
            
        case "03":
            return "31"
        case "04":
            return "30"
            
        case "05":
            return "31"
        case "06":
            return "30"
            
        case "07":
            return "31"
        case "08":
            return "31"
            
        case "09":
            return "3"
        case "10":
            return "31"
            
        case "11":
            return "30"
        case "12":
            return "31"
            
       
       
        default:
            return "30"
        }
        
    }
}




extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //-----------------------------------------------------------------------------------
    // MARK: - collection DataSource & Delegate
    //-----------------------------------------------------------------------------------
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return aryMonth.count
        
        
        
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath as IndexPath) as! MonthCell
        
        cell.lbl_Title.text = aryMonth.object(at: indexPath.row) as? String ?? ""
        if(CurrentSelectedIndex == indexPath.row)
        {
            //43,227,237
            cell.lbl_Title.textColor = UIColor(red: 43/255, green: 227/255, blue: 237/255, alpha: 1.0)
            cell.img.isHidden = false
        }else
        {
            cell.lbl_Title.textColor = UIColor.black
            cell.img.isHidden = true
        }
        
        
        //cell.img.isHidden = false
        return cell
        
    }
    
//    func getStartMonthBYMonth(byMonth:String)->Date
//    {
//
//
//        let createStartingDate:String = "\(currentYear)-\(byMonth)-01"
//
//        print("createStartingDate",createStartingDate)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//        let theDate = dateFormatter.date(from: createStartingDate)
//        return theDate!
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CurrentSelectedIndex = indexPath.row
        self.monthCollectionView.reloadData()
        
        var getMonth = ""
        if(CurrentSelectedIndex+1 > 9)
        {
            getMonth = String(CurrentSelectedIndex+1)
        }else
        {
            getMonth = "0" + String(CurrentSelectedIndex+1)
        }
        
//        let getFirstDateMonth = getStartMonthBYMonth(byMonth:getMonth)
//        let calendar = Calendar.current
//        //let component = calendar.dateComponents([.day,.month,.year], from: Date())
//
//        let comps2 = NSDateComponents()
//        comps2.month = 1
//        comps2.day = -1
//        let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: getFirstDateMonth)
//            //calendar.dateByAddingComponents(comps2, toDate: getFirstDateMonth, options: [])!
//
//        print(endOfMonth)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-MM-dd"
//        let EndMonthDate = dateFormatter.string(from: endOfMonth!)
//        let StartDate = dateFormatter.string(from: getFirstDateMonth)
//        //print(dateFormatter.string(from: endOfMonth!)) // 2015-11-30
        
        
        
        
//        var startOfMonth : NSDate?
//        var lengthOfMonth : TimeInterval = 0
//        Calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: &lengthOfMonth, forDate: Date)
        
        
        
//        let components = calendar.component([.year,.month])
//
//            //Calendar.components([.Year, .Month], fromDate: Date)
//        let comps2 = NSDateComponents()
//        comps2.month = 1
//        comps2.day = -1
//        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startOfMonth, options: [])!
//        print(dateFormatter.stringFromDate(endOfMonth)) // 2015-11-30
//
        
        
        
      
        
       
        let getDateofEnd = getStartMonthDate(getmonth: getMonth)
        
        let StartMonthDate:String = "\(currentYear)-\(getMonth)-01"
        let EndMonthDate:String = "\(currentYear)-\(getMonth)-\(getDateofEnd)"
        
       // print("createStartingDate",EndMonthDate)
        
        let currentIndex = IndexPath(row: CurrentSelectedIndex, section: 0)
        self.monthCollectionView.scrollToItem(at: currentIndex, at: .left, animated: true)
        self.aryData = FMDBQueueManager.shareFMDBQueueManager.GetAllDataBEtweenDate(bymonth: EndMonthDate, byStartingDate: StartMonthDate)
        
        self.tbl.reloadData()
        
        checkNoRecordView()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 1)
        {
            return CGSize(width: 140, height: 80 )
        }else
        {
        return CGSize(width: 120, height: 80 )
        }
        
    }
    
    
}




extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let getObje = self.aryData.object(at: indexPath.row) as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthDetailCell") as! MonthDetailCell
        
        let getDate:String = getObje.value(forKey: "dt") as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let getFinalDate = dateFormatter.date(from: getDate)
        dateFormatter.dateFormat = "dd"
        let getdateINString = dateFormatter.string(from: getFinalDate!)
        
        dateFormatter.dateFormat = "MMM"
        let getMonthINString = dateFormatter.string(from: getFinalDate!)
        
       cell.lbl_Title.text = getObje.value(forKey: "text") as? String ?? ""
        cell.lbl_Day.text = getdateINString
        cell.lbl_Month.text = getMonthINString
        cell.btnEdit.tag = indexPath.row
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

