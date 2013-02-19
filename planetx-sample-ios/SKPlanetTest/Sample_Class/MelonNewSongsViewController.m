//
//  MelonNewSongsViewController.m
//  SKPOPSDKSample
//
//  Created by Lion User on 30/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MelonNewSongsViewController.h"
#import "Const.h"

#import "APIRequest.h"
#import "RequestBundle.h"


@interface MelonNewSongsViewController ()

@end



@implementation MelonNewSongsViewController

@synthesize myTextView;

APIRequest *api;
RequestBundle *reqBundle;


#define URL SERVER_PUBLIC@"/melon/newreleases/songs"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Get Melon New Songs";
    
    reqBundle = [[RequestBundle alloc] init];
    api = [[APIRequest alloc] init];
}

- (void)viewDidUnload
{
    [myTextView release];
    myTextView = nil;
    
    [api release];
    api = nil;
    
    [reqBundle release];
    reqBundle = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)clearResult {
    [myTextView setText:@""];
}

- (void) initRequestBundle
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:@"version"];
    [param setValue:@"1" forKey:@"page"];
    [param setValue:@"10" forKey:@"count"];

    [reqBundle setUrl:URL];
    [reqBundle setParameters:param];
    //[reqBundle setHttpMethod:SKPopHttpMethodGET];
    //[reqBundle setResponseType:SKPopContentTypeJSON];
    [reqBundle setHttpMethod:SKPopHttpMethodGET];
    [reqBundle setRequestType:SKPopContentTypeXML];
    [reqBundle setResponseType:SKPopContentTypeXML];
    
    [param release];
    
    NSLog(@"reqBundle %@", reqBundle.url);
    
}

- (IBAction)requestSync:(id)sender {
    
    [self clearResult];
    

    [self initRequestBundle];
    
    ResponseMessage *result = nil;
    
    NSError *error = nil;
    NSLog(@"reqBundle %@", reqBundle.url);
    result = [api request:reqBundle error:&error];
    
    if ( error ) {
        [myTextView setText:[error localizedDescription]];
    } else {
        [myTextView setText:[NSString stringWithFormat:@"%@\n%@", result.statusCode, result.resultMessage]];
    }
    
    [result release];

}


- (IBAction)requestAsync:(id)sender {
    
    [self clearResult];
    
    [self initRequestBundle];
    
    [api setDelegate:self 
            finished:@selector(testFinished:) 
              failed:@selector(testFailed:)];
    [api aSyncRequest:reqBundle];
    
    
}

#pragma mark

// delegate 함수
-(void)testProgress:(NSDictionary *)result
{
    NSLog(@"testProgress : %@", result);
    [result release];
}

-(void)testFinished:(NSDictionary *)result
{
    NSLog(@"testFinished : %@", result);
    [myTextView setText:[result valueForKey:SKPopASyncResultData]];
    [result release];
}

-(void)testFailed:(NSDictionary *)result
{
    NSLog(@"testFailed : %@", result);
    [myTextView setText:[result valueForKey:SKPopASyncResultMessage]];
    [result release];

}



@end
 