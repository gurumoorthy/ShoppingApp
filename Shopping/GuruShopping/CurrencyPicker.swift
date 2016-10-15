import Foundation
import UIKit

class CurrencyPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var CurrencyPicker: UIPickerView!
   
    let pickerData = CurencyConversion.sharedInstance.currencyChoices
    
    @IBAction func clickDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrencyPicker.dataSource = self
        CurrencyPicker.delegate = self
        let defaultRowIndex = pickerData.indexOf(Cart.sharedInstance.currency)
        
       
        CurrencyPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       CurencyConversion.sharedInstance.getConversionRate(pickerData[row])
        Cart.sharedInstance.calculateTotal()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}