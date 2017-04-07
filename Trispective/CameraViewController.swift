//
//  CameraViewController.swift
//  Trispective
//
//  Created by USER on 2017/4/5.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes=[NSFontAttributeName: UIFont(name: "Helvetica",size: 24)!]
        
        view.addSubview(imageView)
        addMaskLayout()
        imageView.isUserInteractionEnabled=true
        imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panImage(_:))))
        imageView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchImage(_:))))
        
    }
    @IBAction func saveImage(_ sender: UIBarButtonItem) {
        let px=(imageView.frame.width/2-view.frame.width/2+view.center.x-imageView.center.x)/imageView.frame.width
        let py=(imageView.frame.height/2-view.frame.height*0.562/2+view.center.y-imageView.center.y)/imageView.frame.height
        
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: CGRect(x: (image?.size.width)!*px, y: (image?.size.height)!*py, width: view.frame.width/scale, height: view.frame.height*0.562/scale))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
                
        image=croppedImage
    }
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        if let navController=self.navigationController{
//            navController.popViewController(animated: true)
//        }
//    }
    
    func addMaskLayout(){
        let masklayer = CAShapeLayer()
        
        masklayer.isOpaque = false
        masklayer.frame = view.frame
        
        let squareRect = CGRect(x: 0, y: view.center.y-view.frame.height*0.562/2, width: view.frame.width, height: view.frame.height*0.562)
        let path = UIBezierPath(rect: view.frame)
        path.append(UIBezierPath(rect: squareRect))
        path.close()
        
        masklayer.path = path.cgPath
        
        masklayer.fillColor = UIColor(white:0,alpha:0.5).cgColor
        masklayer.fillRule = kCAFillRuleEvenOdd
        
        view.layer.addSublayer(masklayer)
        //self.layer.addSublayer(masklayer)
        
    }
    
    var circleCenter=CGPoint()
    
    func pinchImage(_ gesture:UIPinchGestureRecognizer){
        switch gesture.state {
        case .changed:
            scale=scale*gesture.scale
            gesture.scale=1.0
            imageView.frame.size=CGSize(width: scale*originSize.width, height: scale*originSize.height)
            gesture.view?.center=view.center
            
        case .ended:
            if(scale<minScale){
                scale=minScale
                UIView.animate(withDuration: 0.5, animations: { [weak self] in
                    gesture.view?.frame.size=CGSize(width: (self?.originSize)!.width*(self?.scale)!, height:(self?.originSize)!.height*(self?.scale)!)
                    gesture.view?.center=(self?.view.center)!
                })
            }
        default:
            break
        }
    }
    
    func panImage(_ gesture:UIPanGestureRecognizer ){
        let target=gesture.view!
        
        switch gesture.state{
        case .began:
            circleCenter=target.center
            
        case .changed:
            let translation=gesture.translation(in: self.view)
            target.center=CGPoint(x: circleCenter.x+translation.x,y: circleCenter.y+translation.y)
            
        case .ended:
            let topEdge=view.center.y-view.frame.height*0.562/2
            let downEdge=view.center.y+view.frame.height*0.562/2
            var offsetX:CGFloat=0
            var offsetY:CGFloat=0
            if target.center.x-target.frame.width/2>0{
                offsetX = -(target.center.x-target.frame.width/2)
            }
            if target.center.x+target.frame.width/2<view.frame.width{
                offsetX = view.frame.width-(target.center.x+target.frame.width/2)
            }
            if target.center.y-target.frame.height/2>topEdge{
                offsetY = -(target.center.y-target.frame.height/2-topEdge)
            }
            if target.center.y+target.frame.height/2<downEdge{
                offsetY = downEdge-(target.center.y+target.frame.height/2)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                target.center=CGPoint(x: target.center.x+offsetX, y: target.center.y+offsetY)
            })
            
        default: break
        }
    }

    
    
    var imageView=UIImageView()
    var minScale:CGFloat=1
    var originSize=CGSize()
    var scale:CGFloat=0
    var image:UIImage?{
        get{
            return imageView.image
        }
        set{
            //let imageTemp=UIImage(CGImage: (newValue!.CGImage)!, scale: (newValue!.scale), orientation: UIImageOrientation(rawValue: 3)!)
            //imageView.image=imageTemp
            imageView.image=newValue
            imageView.frame=CGRect(x: 0, y: 0, width: (newValue?.size.width)!, height: (newValue?.size.height)!)
            imageView.contentMode = .scaleToFill
            originSize=imageView.frame.size

            if (image?.size.height)!*view.frame.width/(image?.size.width)!<0.562*view.frame.height{
                scale=view.frame.height*0.562/imageView.frame.height
                imageView.frame.size=CGSize(width: scale*imageView.frame.width, height: scale*imageView.frame.height)
                minScale=scale
            }else{
                scale=view.frame.width/imageView.frame.width
                imageView.frame.size=CGSize(width: scale*imageView.frame.width, height: scale*imageView.frame.height)
                minScale=scale
            }
            
            imageView.center=view.center
           
        }
    }

}
