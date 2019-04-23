//
//  addNote.swift
//  AlineADay
//
//  Created by developer on 29/03/19.
//  Copyright © 2019 AlineADay. All rights reserved.
//

import UIKit
import IQDropDownTextField

class addNote: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtmg: IQDropDownTextField!
    @IBOutlet weak var txtname: UITextField!
    var delegate:addNewCategoryProtocol?
    var isEdit:Bool = false
    var getObj:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtmg.datePickerMode = .date
        txtmg.dropDownMode = .datePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        txtmg.dateFormatter = dateFormatter
        
       // let today = dateFormatter.string(from: NSDate() as Date)
        txtmg.date = NSDate() as Date
        
        if(isEdit == true)
        {
            txtname.text = getObj.value(forKey: "text") as? String ?? ""
            
            let getDate:String = getObj.value(forKey: "dt") as? String ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let getFinalDate = dateFormatter.date(from: getDate)
            txtmg.date = getFinalDate
            
        }
    }
    

    @IBAction func click_Add(sender: UIButton)
    {
        
        
        let getText = self.txtname.text as? String ?? ""
        let getFinalText = getText.trimmingCharacters(in: .whitespaces)
        if(getFinalText.count > 0)
        {
            let getselectedItem:String = self.txtmg.selectedItem ?? ""
            
            if(getselectedItem.count > 0)
            {
                
                if(isEdit == true)
                {
                     let getID:String = getObj.value(forKey: "id") as? String ?? ""
                    //print(getID)
                    FMDBQueueManager.shareFMDBQueueManager.UpdateNotes(getTitle: getFinalText, getdate: getselectedItem,getID: getID)
                    
                    self.dismiss(animated: true, completion: nil)
                    if(delegate != nil)
                    {
                        delegate?.doneContinue()
                    }
                    
                }else
                {
                
                let getData:NSMutableArray = FMDBQueueManager.shareFMDBQueueManager.CheckNOTE(getdate: getselectedItem)
                
                if(getData.count > 0)
                {
                    let otherAlert = UIAlertController(title: "OOPS!", message: "Already added for this date!", preferredStyle: UIAlertController.Style.alert)
                    
                    let printSomething = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                        
                    }
                    
                    // relate actions to controllers
                    otherAlert.addAction(printSomething)
                    present(otherAlert, animated: true, completion: nil)
                    
                }else
                {
                        FMDBQueueManager.shareFMDBQueueManager.insertNOTE(getTitle: getFinalText, getdate: getselectedItem)
                        self.dismiss(animated: true, completion: nil)
                        if(delegate != nil)
                        {
                            delegate?.doneContinue()
                        }
                }
             }
                        
            }else
            {
                let otherAlert = UIAlertController(title: "OOPS!", message: "Please enter date", preferredStyle: UIAlertController.Style.alert)
                
                let printSomething = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
                    
                }
                
                // relate actions to controllers
                otherAlert.addAction(printSomething)
                present(otherAlert, animated: true, completion: nil)
            }
            
            
            
        }else
        {
            
            let otherAlert = UIAlertController(title: "OOPS!", message: "Please enter note", preferredStyle: UIAlertController.Style.alert)
            
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        
        if(textField == txtname )
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ. ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
                return true
            }else
            {
                return false
            }
        }
        
        return false
    }

}
