//
//  UISpinner.swift
//  UISpinner
//
//  Created by hewenfeng on 2018/9/5.
//  Copyright © 2018年 hust. All rights reserved.
//

import UIKit

class UISpinner: UIView {
    var isClicking=false
    var delegate:UISpinnerDelegate?
    var dataSource:UISpinnerDataSource?
    private var table:UITableView=UITableView()
    private var title:UILabel=UILabel()
    private var arrow:UIImageView=UIImageView()
    private var base:UIView=UIView()
    convenience init() {
        let point=CGRect(x: 0, y: 0, width: 0, height: 0)
        self.init(frame: point)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(base)
        addSubview(table)
        base.addSubview(title)
        base.addSubview(arrow)
        base.backgroundColor = .clear
        base.frame.size=frame.size
        base.frame.origin=CGPoint(x: 0, y: 0)
        let ges=UITapGestureRecognizer(target: self, action: #selector(click(recognizer:)))
        self.base.addGestureRecognizer(ges)
        title.textAlignment = .center
        title.textColor = .black
        
        arrow.image=UIImage(named: "下箭头灰")
        table.frame=CGRect(x: 0, y: frame.height, width: frame.width, height: 0)
        
        table.delegate=self
        table.dataSource=self
        table.backgroundColor = .white
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTitle(p:String) -> Void {
        title.text = p
    }
    func setFont(f:UIFont) -> Void {
        title.font=f
    }	
    override var frame: CGRect{
        get{
            return super.frame
        }
        set{
            print(frame)
            super.frame = newValue
            if !isClicking {
                base.frame.size = newValue.size
                base.frame.origin=CGPoint(x: 0, y: 0)
                let bw=base.frame
                let v1=bw.height*0.6
                let v2=(bw.height-v1)/2
                arrow.frame=CGRect(x: bw.width-v1, y: v2, width: v1, height: v1)
                arrow.layer.cornerRadius=arrow.frame.width/2
                let width_=bw.width-arrow.frame.width
                title.frame=CGRect(x: 0, y: 0, width: width_, height: bw.height)
            }
        }
    }
    @objc func click(recognizer:UITapGestureRecognizer) -> Void {
        isClicking=true
        if table.frame.height>0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.arrow.transform = CGAffineTransform.init(rotationAngle: CGFloat(0))
                self.frame.size=CGSize(width: self.base.frame.width, height: self.base.frame.height)
                self.table.frame=CGRect(x: 0, y: self.base.frame.height, width: self.base.frame.width, height: 0)
            })
        }else {
            UIView.animate(withDuration: 0.2, animations: {
                self.table.frame=CGRect(x: 0, y: self.frame.height, width: self.base.frame.width, height: self.base.frame.height*4)
                self.frame.size=CGSize(width: self.base.frame.width, height: self.base.frame.height+self.table.frame.height)
                self.arrow.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
            })
        }
        setNeedsDisplay()
        isClicking=false
    }
    
}
extension UISpinner:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource != nil {
            return (dataSource?.spinner(tableView, numberOfRowsInSection: section))!
        }
        else {
            return 0;
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource != nil{
            return dataSource!.spinner(tableView, cellForRowAt: indexPath)
        }else {
            return UITableViewCell()
        }
    }
}
extension UISpinner:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if delegate != nil{
            self.delegate?.spinner!(tableView, didSelectRowAt: indexPath)
            self.click(recognizer: UITapGestureRecognizer())
        }
    }
}
