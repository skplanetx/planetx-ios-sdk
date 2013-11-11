//
//  TcloudImagesDeleteViewController.m
//  SKPlanetTest
//
//  Created by Ray on 13. 11. 10..
//
//

#import "TcloudImagesDeleteViewController.h"
#import "Const.h"

#import "APIRequest.h"
#import "RequestBundle.h"

@interface TcloudImagesDeleteViewController ()

@end

@implementation TcloudImagesDeleteViewController

@synthesize myTextView;

APIRequest *api;
RequestBundle *reqBundle;


#define OBJECTID "##OBJECTID"
#define URL SERVER@"/tcloud/images"@OBJECTID

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
    self.navigationItem.title = @"Delete Tcloud Image";
    
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
    
    [reqBundle setUrl:URL];
    [reqBundle setParameters:param];
    [reqBundle setHttpMethod:SKPopHttpMethodDELETE];
    [reqBundle setResponseType:SKPopContentTypeJSON];
    
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
