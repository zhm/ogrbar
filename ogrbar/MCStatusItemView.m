//
//  MCStatusItemView.m
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//

#import "MCStatusItemView.h"
#import "MCOgrUtil.h"

@interface MCStatusItemView ()
@property (readwrite, retain) NSImage *icon;
@property (readwrite, retain) NSImage *iconGlow;
@end

@implementation MCStatusItemView
@synthesize statusItem = _statusItem;
@synthesize isMenuVisible = _isMenuVisible;
@synthesize icon = _icon;
@synthesize iconGlow = _iconGlow;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isMenuVisible = NO;
        self.icon = [NSImage imageNamed:@"pin.png"];
        self.iconGlow = [NSImage imageNamed:@"pin-glow.png"];
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSPasteboardTypeString, nil]];
    }
    return self;
}

- (void)dealloc {
    self.statusItem = nil;
}

- (void)mouseDown:(NSEvent *)event {
    self.menu.delegate = self;
    [self.statusItem popUpStatusItemMenu:self.menu];
    self.needsDisplay = YES;
}

- (void)rightMouseDown:(NSEvent *)event {
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    self.isMenuVisible = YES;
    self.needsDisplay = YES;
}

- (void)menuDidClose:(NSMenu *)menu {
    self.isMenuVisible = NO;
    menu.delegate = nil;  
    self.needsDisplay = YES;
}

- (void)drawRect:(NSRect)rect {
    [self.statusItem drawStatusBarBackgroundInRect:self.bounds
                                     withHighlight:self.isMenuVisible];
    
    NSImage *icon = self.isMenuVisible ? self.iconGlow : self.icon;
    
    [icon drawInRect:CGRectMake(0, 1, 22, 20)
            fromRect:NSZeroRect 
           operation:NSCompositeSourceOver 
            fraction:1];
}

-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

-(NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

-(void)draggingExited:(id <NSDraggingInfo>)sender {
}

-(BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
    return YES;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSLog(@"performDragOperation");
    
    NSData *data = nil;
    NSString *errorDescription = nil;
    NSPasteboard *pasteboard = sender.draggingPasteboard;
    
    NSMutableArray *validFileTypes = [NSMutableArray array];
    
    [validFileTypes addObject:@"csv"];
    [validFileTypes addObject:@"shp"];
    [validFileTypes addObject:@"sql"];
    [validFileTypes addObject:@"json"];
    [validFileTypes addObject:@"sqlite"];
    [validFileTypes addObject:@"tif"];
    [validFileTypes addObject:@"tiff"];
    [validFileTypes addObject:@"kml"];
    
    if ([pasteboard.types containsObject:NSFilenamesPboardType]) {
        data = [pasteboard dataForType:NSFilenamesPboardType];
        
        if (data) {
            NSArray *fileNames = [NSPropertyListSerialization propertyListFromData:data 
                                                                  mutabilityOption:kCFPropertyListImmutable 
                                                                            format:nil 
                                                                  errorDescription:&errorDescription];
            
            for (NSString *fileName in fileNames) {
                BOOL isDirectory = NO;
                
                [[NSFileManager defaultManager] fileExistsAtPath:fileName isDirectory:&isDirectory];
                
                if (isDirectory) {
                    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:fileName];
                    
                    NSString *file;
                    
                    while (file = [dirEnum nextObject]) {
                        if ([validFileTypes containsObject:file.pathExtension]) {
                            NSString *outputFileName = [fileName stringByAppendingPathComponent:[[file stringByDeletingPathExtension] stringByAppendingString:@"_processed.shp"]];
                            [MCOgrUtil transform:[fileName stringByAppendingPathComponent:file] destination:outputFileName format:@"shp" clip:YES append:NO];
                        }
                    }
                } else {
                    NSString *outputFileName = [[fileName stringByDeletingPathExtension] stringByAppendingString:@"_processed.shp"];
                    [MCOgrUtil transform:fileName destination:outputFileName format:@"shp" clip:YES append:NO];
                }
            }
        }
        
    }
    
    return YES;
}

@end
