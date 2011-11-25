//
//  MCOgrUtil.h
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MERCATOR @"+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over"
#define MERCATOR_BOUNDS @"-180.0 -85.05112877980659 180 85.05112877980659"

@interface MCOgrUtil : NSObject
+ (void)transform:(NSString *)source 
      destination:(NSString *)destination 
           format:(NSString *)format 
             clip:(BOOL)clip 
           append:(BOOL)append;

+ (NSString *)findOgrBinary;
@end
