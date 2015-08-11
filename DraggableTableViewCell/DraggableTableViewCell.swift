//
//  DraggableTableViewCell.swift
//  DraggableTableViewCellProject
//
//  Created by Dmitry Sokolov on 8/11/15.
//  Copyright (c) 2015 Dmitry Sokolov. All rights reserved.
//

import UIKit


class DraggableTableViewCell : UITableViewCell {
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var actionOnDragRelease = false
    
    private var onLeftSwipeView: UIView?
    private var onRightSwipeView: UIView?
    
    private var labelOnSwipeLeft: UILabel?
    private var labelOnSwipeRight: UILabel?
    
    
    var colorOnActiveFullSwipeLeft: UIColor?
    var colorOnInactiveSwipeLeft: UIColor?
    
    var colorOnActiveFullSwipeRight: UIColor?
    var colorOnInactiveSwipeRight: UIColor?
    
    var textOnSwipeLeft: String = "Action" {
        didSet {
            self.labelOnSwipeLeft?.text = textOnSwipeLeft
        }
    }
    
    var textOnSwipeRight: String = "Right Action" {
        didSet {
            self.labelOnSwipeRight?.text = textOnSwipeRight
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.registerGesture()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.registerGesture()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func registerGesture() {
        var recognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    private func createCViews() {
        
        // create views
        self.onLeftSwipeView = UIView(frame: CGRectMake(self.frame.origin.x + self.bounds.width, 0, 0, self.bounds.height))
        
        self.onRightSwipeView = UIView(frame: CGRectMake(self.bounds.origin.x, 0, 0, self.bounds.height))
        
        
        // set color on left right
        if let color = self.colorOnInactiveSwipeLeft {
            self.onLeftSwipeView?.backgroundColor = color
        } else {
            self.colorOnInactiveSwipeLeft = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 127.0/255.0, alpha: 1)
            self.onLeftSwipeView?.backgroundColor = self.colorOnInactiveSwipeLeft
        }
        
        if self.colorOnActiveFullSwipeLeft == nil {
            self.colorOnActiveFullSwipeLeft = UIColor(red: 249.0/255.0, green: 61.0/255.0, blue: 0, alpha: 1)
        }
        
        
        // set color on swipe right
        if let color = self.colorOnInactiveSwipeRight {
            self.onRightSwipeView?.backgroundColor = color
        } else {
            self.colorOnInactiveSwipeRight = UIColor(red: 127.0/255.0, green: 127.0/255.0, blue: 127.0/255.0, alpha: 1)
            self.onRightSwipeView?.backgroundColor = self.colorOnInactiveSwipeRight
        }
        
        if self.colorOnActiveFullSwipeRight == nil {
            self.colorOnActiveFullSwipeRight = UIColor.blueColor()
        }
        
        
        // setup label on left swipe
        self.labelOnSwipeLeft = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: self.onLeftSwipeView!.bounds.height))
        
        self.labelOnSwipeLeft?.adjustsFontSizeToFitWidth = true
        self.labelOnSwipeLeft?.textColor = UIColor.whiteColor()
        self.labelOnSwipeLeft?.textAlignment = NSTextAlignment.Center
        self.labelOnSwipeLeft?.font = UIFont(name: "Avenir", size: 15.0)
        self.labelOnSwipeLeft?.text = self.textOnSwipeLeft
        
        
        
        // setup label on right swipe
        self.labelOnSwipeRight = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: self.onRightSwipeView!.bounds.height))
        
        self.labelOnSwipeRight?.textColor = UIColor.whiteColor()
        self.labelOnSwipeRight?.adjustsFontSizeToFitWidth = true
        self.labelOnSwipeRight?.textAlignment = .Center
        self.labelOnSwipeRight?.font = UIFont(name: "Avenir", size: 15.0)
        self.labelOnSwipeRight?.text = self.textOnSwipeRight
        
        // register left view and label
        self.addSubview(onLeftSwipeView!)
        self.onLeftSwipeView!.addSubview(self.labelOnSwipeLeft!)
        
        // register right view and label
        self.addSubview(onRightSwipeView!)
        self.onRightSwipeView?.addSubview(self.labelOnSwipeRight!)
        
    }
    
    
    
    
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        // gesture began
        if recognizer.state == UIGestureRecognizerState.Began {
            originalCenter = center // set center of the cell
            // create views
            if (self.onLeftSwipeView == nil || self.onRightSwipeView != nil) {
                self.createCViews()
            }
            
            
        }
        
        // gesture in proccess
        if recognizer.state == UIGestureRecognizerState.Changed {
            let translation = recognizer.translationInView(self)
            
            // stop when the translation more than self.bounds.width / 3.0
            if abs(translation.x) < self.bounds.width / 3.0  {
                center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
                
                // swipe left
                if translation.x < 0 {
                    self.deleteOnDragRelease = frame.origin.x < -frame.size.width / 4.0
                    
                    self.onLeftSwipeView?.frame.size.width = translation.x
                    self.onLeftSwipeView?.frame.origin.x = self.bounds.width
                    
                    if self.deleteOnDragRelease {
                        self.onLeftSwipeView?.backgroundColor = self.colorOnActiveFullSwipeLeft
                    } else {
                        self.onLeftSwipeView?.backgroundColor = self.colorOnInactiveSwipeLeft
                    }
                    
                    self.labelOnSwipeLeft?.frame.size.width = abs(self.onLeftSwipeView!.frame.width)
                    
                } else {
                    // swipe right
                    self.actionOnDragRelease = frame.origin.x > frame.size.width / 4.0
                    
                    self.onRightSwipeView?.frame.size.width = translation.x
                    self.onRightSwipeView?.frame.origin.x = 0 - translation.x
                    //                    println(self.superview?.frame.origin.x)
                    
                    if self.actionOnDragRelease {
                        self.onRightSwipeView?.backgroundColor = self.colorOnActiveFullSwipeRight
                    } else {
                        self.onRightSwipeView?.backgroundColor = self.colorOnInactiveSwipeRight
                    }
                    
                    self.labelOnSwipeRight?.frame.size.width = abs(self.onRightSwipeView!.frame.width)
                }
                
            }
            
        }
        
        
        // gesture ended
        if recognizer.state == UIGestureRecognizerState.Ended {
            
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            
            if actionOnDragRelease {
                self.onActionRight()
                actionOnDragRelease = false
            }
            
            // animate setting the cell to its initial position if not on delete
            if (!deleteOnDragRelease) {
                UIView.animateWithDuration(0.3) {
                    self.frame = originalFrame
                    self.onLeftSwipeView?.frame.size.width = 0
                    self.onRightSwipeView?.frame.size.width = 0
                }
                
            } else {
                if deleteOnDragRelease {
                    self.onDeleteCell()
                }
            }
        }
        
    }
    
    
    
    
    func onDeleteCell() {
        self.labelOnSwipeLeft?.removeFromSuperview()
        self.labelOnSwipeLeft = nil
        self.onLeftSwipeView?.removeFromSuperview()
        self.onLeftSwipeView = nil
    }
    
    
    func onActionRight() {
    }
    
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGesture.translationInView(superview!)
            
            // check for only horizontal gesture
            if fabs(translation.x) > fabs(translation.y)
                // and check only for swipe to the right
                //                 && translation.x < 0
            {
                return true
            }
            return false
            
        }
        return false
    }
    
}


class MyCustomCell: DraggableTableViewCell {
    
    var delegate: CustomCellDelegate?
    
    override func onDeleteCell() {
        super.onDeleteCell()
        
        delegate?.onDelete(cell: self)
    }
}
