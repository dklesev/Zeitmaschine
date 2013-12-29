//
//  ViewController.m
//  Zeitmaschine
//
//  Created by Admin on 28.12.13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ViewController.h"
#import "HTMLParser.h"

@interface ViewController () <UIWebViewDelegate>
@property (strong, nonatomic) Model *model;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString* year;
@property (strong, nonatomic) NSString* month;
@property (strong, nonatomic) NSMutableString* url;
@property (strong, nonatomic) HTMLParser* parser;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.WebView setDelegate:self];
    self.url = [[NSMutableString alloc] initWithString:@"http://de.wikipedia.org/wiki/"];
    self.data = [[NSMutableData alloc] init];
}
- (IBAction)dateSelected:(UIDatePicker*)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    self.year = [dateFormatter stringFromDate:[sender date]];
    
    [dateFormatter setDateFormat:@"MMMM"];
    
    self.month = [dateFormatter stringFromDate:[sender date]];
    
    [self.url appendString:self.year];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:self.url]];
    [NSURLConnection connectionWithRequest: request delegate:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"window.location.href = '#Januar';"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.webData = [[NSMutableData alloc] init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error = nil;
    self.parser = [[HTMLParser alloc] initWithData:self.webData error:nil];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    HTMLNode *bodyNode = [self.parser body];
    NSArray *inputNodes = [bodyNode findChildTags:@"li"];
    
    NSString* html_head = @"<!DOCTYPE html><html><head></head><body><ul>";
    [self.data appendData:[html_head dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (HTMLNode *inputNode in inputNodes) {
        if ([[[inputNode firstChild] getAttributeNamed:@"title"] isEqualToString:@"1. Januar"]) {
            //NSLog(@"%@", [inputNode rawContents]);
            [self.data appendData:[[inputNode rawContents] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSString* html_tail = @"</ul></body>";
    [self.data appendData:[html_tail dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.WebView loadData:self.data MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
}


@end
