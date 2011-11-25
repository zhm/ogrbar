//
//  MCOgrUtil.m
//  ogrbar
//
//  Created by Zachary McCormick on 11/25/11.
//  Copyright (c) 2011 Zac McCormick. All rights reserved.
//

#import "MCOgrUtil.h"

@implementation MCOgrUtil

+ (void)transform:(NSString *)source 
      destination:(NSString *)destination 
           format:(NSString *)format 
             clip:(BOOL)clip 
           append:(BOOL)append
{
    NSMutableArray *arguments = [NSMutableArray array];
    
    [arguments addObject:@"-f"];
    
    if ([format isEqualToString:@"shp"]) {
        [arguments addObject:@"ESRI Shapefile"];
    } else {
        [arguments addObject:@"SQLite"];
    }
    
    [arguments addObject:@"-t_srs"];
    [arguments addObject:MERCATOR];
    
    //[arguments addObject:@"-clipsrc"];
    //[arguments addObjectsFromArray:[MERCATOR_BOUNDS componentsSeparatedByString:@" "]];
    
    [arguments addObject:destination];
    [arguments addObject:source];    
    
    NSTask *task = [[NSTask alloc] init];
    

    task.launchPath = [MCOgrUtil findOgrBinary];    
    task.arguments = arguments;
    task.standardOutput = [NSPipe pipe];
    task.standardError = [NSPipe pipe];
    
    NSFileHandle *outputFile = [task.standardOutput fileHandleForReading];
    NSFileHandle *errorFile = [task.standardError fileHandleForReading];
    
    [task launch];
    
    NSData *outputData = [outputFile readDataToEndOfFile];
    NSData *errorData = [errorFile readDataToEndOfFile];
    
    NSString *outputText = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSString *errorText = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Output: %@", outputText);
    NSLog(@"Errors: %@", errorText);
}

+ (NSString *)findOgrBinary {
    NSMutableArray *commonPaths = [NSMutableArray array];
    
    [commonPaths addObject:@"/usr/local/bin/ogr2ogr"];
    [commonPaths addObject:@"/opt/local/bin/ogr2ogr"];
    [commonPaths addObject:@"/Library/Frameworks/GDAL.framework/Programs/ogr2ogr"];
    
    for (NSString *commonPath in commonPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:commonPath]) {
            return commonPath;
        }
    }
    
    return @"ogr2ogr";
}

@end
