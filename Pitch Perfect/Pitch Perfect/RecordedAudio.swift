//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Padmaja Arekuti on 3/30/15.
//  Copyright (c) 2015 Padmaja Arekuti. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init (url:NSURL!, fileTitle:String!){
        filePathUrl = url
        title = fileTitle
    }
}