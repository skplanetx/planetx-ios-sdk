//
//  CyworldNoteUploadFileViewController.m
//  SKPOPSDKSample
//
//  Created by Lion User on 01/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CyworldNoteUploadFileViewController.h"
#import "Const.h"

#import "APIRequest.h"
#import "RequestBundle.h"

@interface CyworldNoteUploadFileViewController ()

@end

@implementation CyworldNoteUploadFileViewController

@synthesize myTextView;
@synthesize filePathTextField;

APIRequest *api;
RequestBundle *reqBundle;

#define USERID @"67324899"
#define URL SERVER@"/cyworld/note/"USERID@"/imageupload"


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
    self.navigationItem.title = @"Upload Cyworld Image";
    
    reqBundle = [[RequestBundle alloc] init];
    api = [[APIRequest alloc] init];
}

- (void)viewDidUnload
{
    [myTextView release];
    myTextView = nil;
    [filePathTextField release];
    filePathTextField = nil;
    
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
    
    NSString *uploadFilePath = [filePathTextField text];
    
    reqBundle = [[RequestBundle alloc] init];
    [reqBundle setUrl:URL];
    [reqBundle setParameters:param];
    [reqBundle setHttpMethod:SKPopHttpMethodPOST];
    [reqBundle setResponseType:SKPopContentTypeJSON];
    [reqBundle setUploadFileKey:@"image"];
    [reqBundle setUploadFilePath:uploadFilePath];
    
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
            finished:@selector(apiRequestFinished:) 
              failed:@selector(apiRequestFailed:)];
    [api aSyncRequest:reqBundle];
    
}

- (IBAction)pickImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    //you can use UIImagePickerControllerOriginalImage for the original image
    
    //Now, save the image to your apps temp folder, 
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"upload-image.jpg"];
    NSData *imageData = UIImagePNGRepresentation(img);
    //you can also use UIImageJPEGRepresentation(img,1); for jpegs
    [imageData writeToFile:path atomically:YES];
    
    //now call your method
    [filePathTextField setText:path];
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - SKPOP SDK Delegate

-(void)apiRequestFinished:(NSDictionary *)result
{
    NSLog(@"apiRequestFinished : %@", result);
    [myTextView setText:[result valueForKey:SKPopASyncResultData]];
    [result release];
}

-(void)apiRequestFailed:(NSDictionary *)result
{
    NSLog(@"apiRequestFailed : %@", result);
    [myTextView setText:[result valueForKey:SKPopASyncResultMessage]];
    [result release];
    
}



@end
