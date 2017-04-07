//
//  SideMenuController.swift
//  Trispective
//
//  Created by USER on 2017/4/1.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit

class SideMenuController:NSObject,UITableViewDelegate,UITableViewDataSource {
    
    override init() {
        super.init()
        tableView.delegate=self
        tableView.dataSource=self
        
        tableView.register(MiddleCell.classForCoder(), forCellReuseIdentifier: "middleCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoImage.middleCellImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "middleCell", for: indexPath) as! MiddleCell
        
        cell.icons.image=UIImage(named: DemoImage.middleCellImage[indexPath.row])
        cell.textView.text=DemoImage.middleText[indexPath.row]
        
        
        return cell
    }
    
    let blackView=UIView()
    let menuView:UIView={
        let mv=UIView(frame: .zero)
        mv.backgroundColor=UIColor.white
        return mv
    }()
    
    let backgroundView=UIImageView()
    let avatarView=UIImageView()
    let userNameView=UILabel()
    let tableView=UITableView()
    func setSidebar() {
        if let window=UIApplication.shared.keyWindow{
            blackView.backgroundColor=UIColor(white: 0, alpha: 0.5)
            blackView.frame=window.frame
            blackView.alpha=0
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissSidebar(_:))))
            
            menuView.frame=CGRect(x: 0, y: 0, width: 0, height: window.frame.height)
            menuView.clipsToBounds=true
            
            backgroundView.frame=CGRect(x: 0, y: 0, width: window.frame.width*0.7, height: window.frame.height*0.24)
            backgroundView.image=UIImage(named: "b1")
            backgroundView.contentMode = .scaleToFill
            
            avatarView.frame.size=CGSize(width: backgroundView.frame.width/2, height: backgroundView.frame.height/2)
            avatarView.contentMode = .scaleAspectFit
            avatarView.center=backgroundView.center
            avatarView.image=UIImage(named: "Shaq")
            backgroundView.addSubview(avatarView)
            
            userNameView.text="Martin Smith"
            userNameView.font=UIFont(name: "Helvetica",size: 18)
            userNameView.textColor=UIColor.white
            userNameView.frame=CGRect(x: 0, y: backgroundView.frame.height*0.75, width: backgroundView.frame.width, height: backgroundView.frame.height*0.25)
            userNameView.textAlignment = .center
            backgroundView.addSubview(userNameView)
            
            menuView.addSubview(backgroundView)
            
            let middleView=UIView(frame: CGRect(x: 0, y: backgroundView.frame.height, width: backgroundView.frame.width, height: window.frame.height*0.5))
            
            tableView.frame=CGRect(x: 0, y: 0, width: middleView.frame.width, height: middleView.frame.height)
            tableView.rowHeight=middleView.frame.height/5
            middleView.addSubview(tableView)
            
            menuView.addSubview(middleView)
            
            let downImageView=UIImageView(frame: CGRect(x: 0, y: window.frame.height*0.74, width: middleView.frame.width/2, height: window.frame.height*0.26/2))
            downImageView.center=CGPoint(x: middleView.frame.width/2, y: window.frame.height*0.87)
            downImageView.contentMode = .scaleAspectFit
            downImageView.image=UIImage(named: "TabSpot")
            
            //downView.addSubview(downImageView)
            
            menuView.addSubview(downImageView)
            
            
            window.addSubview(blackView)
            window.addSubview(menuView)
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.blackView.alpha=1
                self?.menuView.frame.size.width = window.frame.width*0.7
            })
        }
        
        
    }
    
    func dismissSidebar(_ gesture:UIGestureRecognizer){
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.blackView.alpha=0
            self?.menuView.frame.size.width=0
        }
    }
    
    
}
