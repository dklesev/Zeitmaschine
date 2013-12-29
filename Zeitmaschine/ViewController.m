//
//  ViewController.m
//  Zeitmaschine
//
//  Created by Admin on 28.12.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ViewController.h"
#import "HTMLParser.h"

@interface ViewController ()
@property (strong, nonatomic) Model *model;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString* year;
@property (strong, nonatomic) NSString* dayAndMonth;
@property (strong, nonatomic) NSMutableString* url;
@property (strong, nonatomic) HTMLParser* parser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.url = [[NSMutableString alloc] initWithString:@"http://de.wikipedia.org/wiki/"];
}
- (IBAction)dateSelected:(UIDatePicker*)sender {
    
    // Go to model or hell
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    self.year = [dateFormatter stringFromDate:[sender date]];

    [dateFormatter setDateFormat:@"d. MMMM"];
    
    //[dateFormatter setDateFormat:@"MMMM d"]; //For US
    
    self.dayAndMonth = [dateFormatter stringFromDate:[sender date]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.url, self.year]]];
    [NSURLConnection connectionWithRequest: request delegate:self]; //Always asynchronous see script
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    // To clean up old garbage
    self.data = [[NSMutableData alloc] init];
    self.webData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // Init Parser - this one is really bad :|
    // This should be moved to model (all parsing shit)
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
    [self.data appendData:[html_head dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Go trough array and look for our nodes needed
    for (HTMLNode *inputNode in inputNodes) {
        if ([[inputNode contents] hasPrefix:self.dayAndMonth] ||
            [[[inputNode firstChild] getAttributeNamed:@"title"] isEqualToString:self.dayAndMonth]) {
            [self.data appendData:[[inputNode rawContents] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    // Append end part
    NSString* html_tail = @"</ul></body>";
    [self.data appendData:[html_tail dataUsingEncoding:NSUTF8StringEncoding]];
    [self.WebView loadData:self.data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
}


@end
