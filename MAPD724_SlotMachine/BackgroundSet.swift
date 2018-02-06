//
//  BackgroundSet.swift
//  MAPD724_SlotMachine
//  Team Members:
//  Akshit Upneja (300976590)
//  santhosh damodharan (300964037)
//  Amanpreet Kaur (300966930)
//  Created by Akshit Upneja on 2018-02-03.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation
import UIKit
//Extending UI View to set background to all the SCreen Sizes
extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "background.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }}



extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}


//Extending UI view controller to animate Bar Image


extension UIViewController{
    func animate(view : UIImageView, images : [UIImage] , duration : TimeInterval , repeatCount : Int){
        view.animationImages = images
        view.animationDuration = duration
        view.animationRepeatCount = repeatCount
        view.startAnimating()
    }
}


extension UIImage{
    
    func spriteSheet(cols : UInt, rows : UInt) -> [UIImage]{
        
        let w = self.size.width / CGFloat(cols)
        let h = self.size.height / CGFloat(rows)
        
        var rect = CGRect(x: 0, y: 0, width: w, height: h)
        var arr : [UIImage] = []
        
        for _ in 0..<rows{
            for _ in 0..<cols{
                
                //crop
                let subImage = self.crop(rect)
                //add to array
                arr.append(subImage)
                
                //go to next image in row
                rect.origin.x += w
            }
            
            //go to next row
            //rect.origin.x = 0
            //rect.origin.y += h
        }
        
        //done, return the array
        return arr
        
    }
    
    
    func crop(_ rect : CGRect) -> UIImage{
        guard let imageRef = self.cgImage?.cropping(to: rect) else {
            return UIImage()
        }
        return UIImage(cgImage: imageRef)
    }
    
}





