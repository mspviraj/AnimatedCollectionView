//
//  GCDUtils.swift
//  AnimatedCollectionView
//
//  Created by Patrick Lynch on 6/17/16.
//  Copyright © 2016 Patrick Lynch. All rights reserved.
//

import Foundation

func dispatch_after( delay:Double, closure:()->() ) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func dispatch_main( closure:()->() ) {
    dispatch_async( dispatch_get_main_queue(), {
        closure()
    })
}