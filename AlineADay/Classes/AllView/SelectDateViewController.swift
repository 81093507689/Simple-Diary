//
//  SelectDateViewController.swift
//  AlineADay
//
//  Created by developer on 30/03/19.
//  Copyright © 2019 AlineADay. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var thedate: UIPickerView!
    var delegate:addNewCategoryProtocol?
    var selectedYear:String = ""
    
    var pickerData:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        let df = DateFormatter()
       // print(df.years(2000...2030))
        pickerData = df.years(2000...2030) as NSArray
        
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let getindex = pickerData.index(of: selectedYear)
        print(getindex)
        if(getindex != NSNotFound)
        {
            thedate.selectRow(getindex, inComponent: 0, animated: false)
        }
    }

    
    @IBAction func click_Add(sender: UIButton)
    {
        
        if(selectedYear.count > 0)
        {
            self.dismiss(animated: true, completion: nil)
            if(delegate != nil)
            {
                delegate?.doneDateSelected(getDate: selectedYear)
            }
        }else
        {
            let otherAlert = UIAlertController(title: "OOPS!", message: "Please select Year", preferredStyle: UIAlertController.Style.alert)
            
            let printSomething = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                
            }
            
            // relate actions to controllers
            otherAlert.addAction(printSomething)
            present(otherAlert, animated: true, completion: nil)
        }
        
        
        
    }
    
    
    
    
    
    @IBAction func click_cancel(sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData.object(at: row) as? String ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let getDate = pickerData.object(at: row) as? String ?? ""
        selectedYear = getDate
        
    }
    
}



extension DateFormatter {
    func years<R: RandomAccessCollection>(_ range: R) -> [String] where R.Iterator.Element == Int {
        setLocalizedDateFormatFromTemplate("yyyy")
        var comps = DateComponents(month: 1, day: 1)
        var res = [String]()
        for y in range {
            comps.year = y
            if let date = calendar.date(from: comps) {
                res.append(string(from: date))
            }
        }
        
        return res
    }
}
