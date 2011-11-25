//
//  MCMenuItem.m
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//


#import "MCMenuItem.h"
#import "MCStatusItemView.h"

@interface MCMenuItem ()
@property (readwrite, retain) NSStatusItem *statusItem;
@property (readwrite, retain) MCStatusItemView *statusItemView;
@end

@implementation MCMenuItem
@synthesize statusItem = _statusItem;
@synthesize mainMenu = _mainMenu;
@synthesize statusItemView = _statusItemView;

- (void)awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusItemView = [[MCStatusItemView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    self.statusItemView.statusItem = self.statusItem;
    self.statusItemView.menu = self.mainMenu;

    self.statusItem.toolTip = @"OGRBar";
    [self.statusItem setView:self.statusItemView];
    self.statusItem.highlightMode = YES;

    //[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    //self.statusItem.action = @selector()

}

- (IBAction)convertDataClicked:(id)sender {
    
}

- (IBAction)quitClicked:(id)sender {
    [NSApp terminate:self];
}

-(void)dealloc {
    self.statusItem = nil;
}

@end
