//
//  Model.m
//  Zeitmaschine
//
//  Created by Admin on 29.12.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "Model.h"

@implementation Model

-(id)initWithURL:(NSString *)url{
    if ([super init]==nil) return nil;
    
    self.url = url;
    
    return self;
}

-(void)cleanUp{
    // To clean up old garbage
    self.mData = [[NSMutableData alloc] init];
    self.webData = [[NSMutableData alloc] init];
}

-(void)setDate:(NSDate*)date{
    // Go to model or hell
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    self.year = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"d. MMMM"];
    
    //[dateFormatter setDateFormat:@"MMMM d"]; //For US
    
    self.dayAndMonth = [dateFormatter stringFromDate:date];
}

-(NSURL*)actualURL{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.url, self.year]];
}

-(NSMutableData*)parseData{
    
    // Init Parser - this one is really bad :|
    NSError *error = nil;
    self.parser = [[HTMLParser alloc] initWithData:self.webData error:nil];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    // Get all li elements
    HTMLNode *bodyNode = [self.parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"li"];
    
    // Prepare the html doc
    NSString* html_head = @"<!DOCTYPE html><html><head></head><body><ul>";
    [self.mData appendData:[html_head dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Go trough array and look for our nodes needed
    for (HTMLNode *inputNode in inputNodes) {
        if ([[inputNode contents] hasPrefix:self.dayAndMonth] ||
            [[[inputNode firstChild] getAttributeNamed:@"title"] isEqualToString:self.dayAndMonth]) {
            [self.mData appendData:[[inputNode rawContents] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // Append end part
    NSString* html_tail = @"</ul></body>";
    [self.mData appendData:[html_tail dataUsingEncoding:NSUTF8StringEncoding]];
    
    return self.mData;
}

@end
