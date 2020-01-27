//
//  Extentions.swift
//  Notes
//
//  Created by Sandeep Kumar on 1/26/20.
//  Copyright © 2020 Sandeep Kumar. All rights reserved.
//

import UIKit

extension UIView
{
    @IBInspectable var bWidth:CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
            
        }
    }
    
    @IBInspectable var cRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var bColor:UIColor{
        get{
            return UIColor.clear
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
    
    //Shadow
    @IBInspectable var sRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable var sOffSet:CGSize{
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var sOpacity:Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var sColor:UIColor{
        get{
            return UIColor.clear
        }
        set{
            layer.shadowColor = newValue.cgColor
        }
    }
}
