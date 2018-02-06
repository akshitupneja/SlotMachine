//
//  ViewController.swift
//  MAPD724_SlotMachine
//  Team Members:
//  Akshit Upneja (300976590)
//  santhosh damodharan (300964037)
//  Amanpreet Kaur (300966930)
//  Created by Akshit Upneja on 2018-02-03.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var coin: UIImageView!
    
    @IBOutlet weak var cashLabel: UILabel!
    
    @IBOutlet weak var barHandle: UIImageView!
    
    @IBOutlet weak var jackpotLabel: UILabel!
    @IBOutlet weak var slotPicker: UIPickerView!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var all: UIButton!
    @IBOutlet weak var hundredDollars: UIButton!
    @IBOutlet weak var fiftyDollars: UIButton!
    @IBOutlet weak var tenDollars: UIButton!
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var betAmountLabel: UILabel!
    let images = [#imageLiteral(resourceName: "dimond"),#imageLiteral(resourceName: "crown"),#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "seven"),#imageLiteral(resourceName: "cherry"),#imageLiteral(resourceName: "lemon")]
    
    var cash = 1000
    var bet = 0
    var jackpot = 0
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addBackground()
        intializeValues()
        
        
        // swipeDown GestureRecognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //Button Actions
    
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        switch sender {
        case tenDollars:
            if (10 > cash){
                self.showAlertWithText(
                    header: "Not Enough Credits",
                    message: ""
                )
            }
            else{
            bet = bet + 10
            jackpot = bet * 10
            cash = cash - 10
            }
        case fiftyDollars:
            if (50 > cash){
                self.showAlertWithText(
                    header: "Not Enough Credits",
                    message: ""
                )
            }
            else{
                bet = bet + 50
                jackpot = bet * 10
                cash = cash - 50
            }
        case hundredDollars:
            if (100 > cash){
                self.showAlertWithText(
                    header: "Not Enough Credits",
                    message: "Bet Less"
                )
            }
            else{
                bet = bet + 100
                jackpot = bet * 10
                cash = cash - 100
            }
        case all:
                bet = bet + cash
                jackpot = bet * 10
                cash = 0
        case reset:
                cash = cash + bet
                bet = 0
                jackpot = bet * 10
                cash = 1000
        
        case exit :
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                    cash = 1000
                    bet = 0
                    jackpot = 0
                    statusLabel.text = "RESET DONE"
        default: break
            
        }
        
        intializeValues()
    }
    
    
    //Alert Action
    
    func showAlertWithText(header:String = "Warning", message:String) {
        let alert = UIAlertController(
            title: header,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.default,
                handler: nil
            )
        )
        
        self.present(alert,
                     animated: true,
                     completion: nil
        )
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

    //SPIN
    
    @IBAction func barAction(_ sender: UITapGestureRecognizer) {
        spinAction()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down: self.spinAction()
            default:break
            }
        }
    }
    
    
    func spinAction(){
        if (bet == 0){
//            self.showAlertWithText(
//                header: "Bet Amount is 0",
//                message: "Please Bet some amount"
            statusLabel.font = UIFont(name:"Arial", size: 20.0)
            statusLabel.text = "Please Select Bet Amount"
            
            
        }
        else{
            statusLabel.font = UIFont(name:"PhosphateSolid", size: 36.0)
            barHandle.isUserInteractionEnabled = false // disable clicking
            // animation of bandit handle
            self.animate(view: barHandle, images: #imageLiteral(resourceName: "mot").spriteSheet(cols: 14, rows: 1), duration: 0.3, repeatCount: 1)
            statusLabel.text = ""
            // Model.instance.play(sound: Constant.spin_sound)
            roll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.checkResult()
                self.barHandle.isUserInteractionEnabled = true
            }
            
        }
        
        
    }

    func roll(){ // roll pickerview
        // iterate over each component, set random img
        for i in 0..<slotPicker.numberOfComponents{
            DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                self.randomSelectRow(in: i)
            })
        }
    }
    
    // get random number
    func randomSelectRow(in comp : Int){
        let r = Int(arc4random_uniform(UInt32(32 * images.count))) + images.count

        slotPicker.selectRow(r, inComponent: comp, animated: true)
        
    }
    
    
// Result
    func checkResult(){
        var lastRow = -1
        var counter = 0
        
        for i in 0..<slotPicker.numberOfComponents{
            let row : Int = slotPicker.selectedRow(inComponent: i) % images.count // selected img idx
            if lastRow == row{ // two equals indexes
                counter += 1
            } else {
                lastRow = row
                counter = 1
            }
        }
        
        if counter == 3{ // winning
            //Model.instance.play(sound: Constant.win_sound)
            //animate(view: machineImageView, images: [#imageLiteral(resourceName: "machine"),#imageLiteral(resourceName: "machine_off")], duration: 1, repeatCount: 15)
            animate(view: coin, images: [#imageLiteral(resourceName: "Coin"),#imageLiteral(resourceName: "Coin")], duration: 1, repeatCount: 15)
            
            statusLabel.font = UIFont(name:"PhosphateSolid", size: 24.0)
            statusLabel.text = "YOU WON \(jackpot)$"
            cash = cash + jackpot
           
        } else { // losing
            statusLabel.text = "TRY AGAIN"
            bet = 0
        }
        
        intializeValues()
        
        
        
    }

    
    //Initial Values
    private func intializeValues() {
        //cash = cash - bet
        //jackpot = bet * 10
        cashLabel.text = "$\(cash)"
        jackpotLabel.text = "$\(jackpot)"
        betAmountLabel.text  = "$\(bet)"
        
    }
}

