//
//  ViewController.swift
//  MAPD724_SlotMachine
//
//  Created by Akshit Upneja on 2018-02-03.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {

    
    let images = [#imageLiteral(resourceName: "dimond"),#imageLiteral(resourceName: "crown"),#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "cherry"),#imageLiteral(resourceName: "lemon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addBackground()
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 50
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let index = row % images.count
        return UIImageView(image: images[index])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return images[component].size.height + 10
    }

}

