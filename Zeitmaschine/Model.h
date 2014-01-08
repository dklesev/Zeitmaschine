//
//  Model.h
//  Zeitmaschine
//
//  Created by Admin on 29.12.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h"

@interface Model : NSObject

@property (strong, nonatomic) HTMLParser* parser;
@property (strong, nonatomic) NSString* year;
@property (strong, nonatomic) NSString* dayAndMonth;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSMutableData *mData;
@property (strong, nonatomic) NSMutableData *webData;

-(id)initWithURL:(NSString*)url;


-(void)cleanUp;

-(NSMutableData*)parseData;

-(void)setDate:(NSDate*)date;

-(NSURL*)actualURL;

@end
