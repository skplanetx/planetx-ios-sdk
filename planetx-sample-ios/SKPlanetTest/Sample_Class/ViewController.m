//
//  ViewController.m
//  SKPOPSDKDev
//
//  Created by Lion User on 23/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "APIRequest.h"
#import "OAuthInfoManager.h"

#import "Const.h"

#import "MelonNewSongsViewController.h"
#import "ElevenStreetCategoriesViewController.h"
#import "TcloudImagesViewController.h"
#import "TcloudImagesDeleteViewController.h"
#import "TcloudImageTagsViewController.h"

@interface ViewController ()

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"SKPOP SDK Sample";    
    

    [APIRequest setAppKey:@"##APPKEY_INPUTHERE##"];

    OAuthInfoManager *oaim = [OAuthInfoManager sharedInstance];
    [oaim setClientId:@"##CLIENTID_INPUTHERE##"];
    [oaim setClientSecret:@"##CLIENTSECRET_INPUTHERE##"];
    [oaim setScope:@"##SCOPE_INPUTHERE##"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)loginButton:(id)sender {  
    OAuthInfoManager *oaim = [OAuthInfoManager sharedInstance];
    [oaim login:self
       finished:@selector(oAuthLoginFinished:)
         failed:@selector(oAuthLoginFailed::)];
}

- (IBAction)getMelonNewSongsButton:(id)sender {
    MelonNewSongsViewController *vc = [[MelonNewSongsViewController alloc]
                                          initWithNibName:@"MelonNewSongsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)getElevenStreetCategoriesButton:(id)sender {
    ElevenStreetCategoriesViewController *vc = [[ElevenStreetCategoriesViewController alloc]
                                       initWithNibName:@"ElevenStreetCategoriesViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)getTcloudImagesButton:(id)sender {
    TcloudImagesViewController *vc = [[TcloudImagesViewController alloc]
                                       initWithNibName:@"TcloudImagesViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)deleteTcloudImageButton:(id)sender {
    TcloudImagesDeleteViewController *vc = [[TcloudImagesDeleteViewController alloc]
                                       initWithNibName:@"TcloudImagesDeleteViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)postTcloudImageTagsButton:(id)sender {
    TcloudImageTagsViewController *vc = [[TcloudImageTagsViewController alloc]
                                       initWithNibName:@"TcloudImageTagsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - SKPOP SDK Delegate

-(void)oAuthLoginFinished:(NSDictionary *)result
{
    NSLog(@"apiRequestFinished : %@", result);
}

-(void)oAuthLoginFailed:(NSDictionary *)result
{
    NSLog(@"apiRequestFailed : %@", result);
    
}

@end

