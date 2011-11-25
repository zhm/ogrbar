//
//  MCStatusItemView.h
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCStatusItemView : NSView<NSMenuDelegate>

@property (retain, nonatomic) NSStatusItem *statusItem;
@property (readwrite, assign) BOOL isMenuVisible;
@end
