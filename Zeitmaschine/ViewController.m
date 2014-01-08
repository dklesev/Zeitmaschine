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

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.model = [[Model alloc] initWithURL:@"http://de.wikipedia.org/wiki/"];
    
}

- (IBAction)dateSelected:(UIDatePicker*)sender {
    
    [self.model setDate:[sender date]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [self.model actualURL]];
    [NSURLConnection connectionWithRequest: request delegate:self]; //Always asynchronous see script
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [self.model cleanUp];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.model.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self.WebView loadData:[self.model parseData] MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
}


@end
