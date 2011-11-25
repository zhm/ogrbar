//
//  MCMenuItem.h
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCMenuItem : NSView <NSMenuDelegate>

@property (readwrite, retain) IBOutlet NSMenu *mainMenu;

@end
