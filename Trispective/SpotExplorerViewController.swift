//
//  SpotExplorerViewController.swift
//  Trispective
//
//  Created by USER on 2017/3/29.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SpotExplorerViewController: UIViewController{
    
    var index:Int=0{
        didSet{
            image=UIImage(named: DemoImage.imageName[index])
            
            //set imageView
            imageView.center=circleCenter
            let transform1=CGAffineTransform(translationX: circleCenter.x-imageView.center.x, y: 0)
            imageView.layer.setAffineTransform(transform1)
            
            //set RightImageView
            if(index<DemoImage.imageName.count-1){
                rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
            }
            rightImageView.center=CGPoint(x: imageView.center.x+imageView.frame.size.width,y: imageView.center.y)
            let transform2=CGAffineTransform(translationX: imageView.center.x+imageView.frame.size.width-rightImageView.center.x, y: 0)
            rightImageView.layer.setAffineTransform(transform2)
            
            //set LeftImageView
            if(index>0){
                leftImageView.image=UIImage(named: DemoImage.imageName[index-1])
            }
            leftImageView.center=CGPoint(x: imageView.center.x-imageView.frame.size.width,y: imageView.center.y)
            let transform3=CGAffineTransform(translationX: imageView.center.x-imageView.frame.size.width-leftImageView.center.x, y: 0)
            leftImageView.layer.setAffineTransform(transform3)
        }
    }
    
    var circleCenter=CGPoint()
    let rightImageView=UIImageView()
    let leftImageView=UIImageView()
    
    @IBOutlet weak var imageView: UIImageView!{
        didSet{
 
            
            //gestures
            let rightSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight(_:)))
            rightSwipeGesture.direction = .right
            imageView.addGestureRecognizer(rightSwipeGesture)
            
            let leftSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft(_:)))
            leftSwipeGesture.direction = .left
            imageView.addGestureRecognizer(leftSwipeGesture)
            
            let downSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown(_:)))
            downSwipeGesture.direction = .down
            imageView.addGestureRecognizer(downSwipeGesture)
            
            let upSwipeGesture=UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp(_:)))
            upSwipeGesture.direction = .up
            imageView.addGestureRecognizer(upSwipeGesture)
            
            
            
            let panGesture=UIPanGestureRecognizer(target: self, action: #selector(self.panImage(_:)))
            panGesture.require(toFail: downSwipeGesture)
            panGesture.require(toFail: upSwipeGesture)
            imageView.addGestureRecognizer(panGesture)
        }
    }
    
    var image:UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image=newValue
        }
        
    }
    
    
    func panImage(_ gesture:UIPanGestureRecognizer){
        let target=gesture.view!
        
        switch gesture.state{
        case .began:
            circleCenter=target.center
            
        case .ended:
            if target.center.x<circleCenter.x{
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    let transform=CGAffineTransform(translationX: -target.frame.size.width+((self?.circleCenter.x)!-target.center.x), y: 0)
                    target.layer.setAffineTransform(transform)
                    self?.rightImageView.layer.setAffineTransform(transform)
                }, completion: { [weak self] (true) in
                    self?.index += 1
                })
                
                
            }else if target.center.x>circleCenter.x{
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                    let transform=CGAffineTransform(translationX: target.frame.size.width-(-(self?.circleCenter.x)!+target.center.x), y: 0)
                    target.layer.setAffineTransform(transform)
                    self?.leftImageView.layer.setAffineTransform(transform)
                    }, completion: { [weak self] (true) in
                        self?.index -= 1
                })
            }
            
            //target.center=circleCenter
            
        case .changed:
            let translation=gesture.translation(in: self.view)
            if (translation.x<0 && index<DemoImage.imageName.count-1) || (translation.x>0 && index>0){
                imageView.center=CGPoint(x: circleCenter.x+translation.x,y: circleCenter.y)
                rightImageView.center=CGPoint(x: circleCenter.x+target.frame.size.width+translation.x,y: circleCenter.y)
                leftImageView.center=CGPoint(x: circleCenter.x-target.frame.size.width+translation.x,y: circleCenter.y)
            }
            
        default: break
        }
    }
    
    func swipeDown(_ gesture:UIGestureRecognizer){
        print("down")
    }
    
    func swipeUp(_ gesture:UIGestureRecognizer){
        print("up")
    }
    
    func swipeRight(_ gesture:UIGestureRecognizer){
        if(index != 0){
            imageView.slideIn(i: 1)
            index -= 1
        }
    }
    
    func swipeLeft(_ gesture:UIGestureRecognizer){
        if(index != DemoImage.imageName.count-1){
            imageView.slideIn(i: -1)
            index += 1
        }
    }
    
    @IBOutlet weak var backArrowButton: UIButton!
    @IBOutlet weak var forwardArrowButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func backArraowFunc(_ sender: UIButton) {
        if(index != 0){
            backArrowButton.isEnabled=false
            forwardArrowButton.isEnabled=false
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                let transform=CGAffineTransform(translationX: (self?.imageView.frame.size.width)!, y: 0)
                self?.imageView.layer.setAffineTransform(transform)
                self?.leftImageView.layer.setAffineTransform(transform)
                }, completion: { [weak self] (true) in
                    self?.index -= 1
                    self?.backArrowButton.isEnabled=true
                    self?.forwardArrowButton.isEnabled=true
            })
        }
    }
    
    @IBAction func forwardArrowFunc(_ sender: UIButton) {
        if(index != DemoImage.imageName.count-1){
            forwardArrowButton.isEnabled=false
            backArrowButton.isEnabled=false
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                let transform=CGAffineTransform(translationX: -(self?.imageView.frame.size.width)!, y: 0)
                self?.imageView.layer.setAffineTransform(transform)
                self?.rightImageView.layer.setAffineTransform(transform)
                }, completion: { [weak self] (true) in
                    self?.index += 1
                    self?.forwardArrowButton.isEnabled=true
                    self?.backArrowButton.isEnabled=true
            })
        }
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        if backArrowButton.alpha==0{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.switchButtons(i: 1, valid: true)
            })
        }else{
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.switchButtons(i: 0, valid: false)
            })
        }
    }
    
    func switchButtons(i:CGFloat,valid:Bool){
        backArrowButton.alpha=i
        backArrowButton.isEnabled=valid
        forwardArrowButton.alpha=i
        forwardArrowButton.isEnabled=valid
        saveButton.alpha=i
        saveButton.isEnabled=valid
        shareButton.alpha=i
        shareButton.isEnabled=valid
    }
    
    let sideMenuController=SideMenuController()
    @IBAction func showSidebar(_ sender: UIButton) {
        sideMenuController.setSidebar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: "Helvetica",size: 24)!]
        
        circleCenter=imageView.center
        

        
        switchButtons(i: 0, valid: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //RightImageView
        rightImageView.frame.size=imageView.frame.size
        rightImageView.contentMode = .scaleToFill
        rightImageView.image=UIImage(named: DemoImage.imageName[index+1])
        rightImageView.center=CGPoint(x: imageView.center.x+imageView.frame.size.width,y: imageView.center.y)
        
        //LeftImageView
        leftImageView.frame.size=imageView.frame.size
        leftImageView.contentMode = .scaleToFill
        //leftImageView.image=UIImage(named: DemoImage.imageName[index])
        leftImageView.center=CGPoint(x: imageView.center.x-imageView.frame.size.width,y: imageView.center.y)
        
        view.addSubview(rightImageView)
        view.addSubview(leftImageView)
        
        index=0
    }

    

}

extension UIView {
    func slideIn(i:Int,duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            slideInTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInTransition.type = kCATransitionPush
        
        if i==1{
            slideInTransition.subtype = kCATransitionFromLeft
        }else{
            slideInTransition.subtype = kCATransitionFromRight
        }
        
        slideInTransition.duration = duration
        slideInTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInTransition, forKey: "slideInTransition")
    }
}
