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
#import "NateOnGetProfileViewController.h"
#import "NateOnModProfileViewController.h"
#import "CyworldNoteWriteArticleViewController.h"
#import "CyworldNoteUploadFileViewController.h"
#import "CyworldNoteDeleteArticleViewController.h"

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

/*
 MelonNewSongs
 NateOnGetProfile
 NateOnModProfile
 CLogDeleteArticle
 CLogUploadFile
 CLogWriteArtice
 */
- (IBAction)getMelonNewSongsButton:(id)sender {
    MelonNewSongsViewController *vc = [[MelonNewSongsViewController alloc]
                                          initWithNibName:@"MelonNewSongsViewController" bundle:nil];    
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)getNateOnProfileButton:(id)sender {
    NateOnGetProfileViewController *vc = [[NateOnGetProfileViewController alloc] 
                                          initWithNibName:@"NateOnGetProfileViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)modifyNateOnProfile:(id)sender {
    NateOnModProfileViewController *vc = [[NateOnModProfileViewController alloc] 
                                             initWithNibName:@"NateOnModProfileViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)writeCyworldArticle:(id)sender {
    CyworldNoteWriteArticleViewController *vc = [[CyworldNoteWriteArticleViewController alloc] 
                                             initWithNibName:@"CyworldNoteWriteArticleViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)uploadCyworldImage:(id)sender {
    CyworldNoteUploadFileViewController *vc = [[CyworldNoteUploadFileViewController alloc] 
                                            initWithNibName:@"CyworldNoteUploadFileViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (IBAction)deleteCyworldArticle:(id)sender {
    CyworldNoteDeleteArticleViewController *vc = [[CyworldNoteDeleteArticleViewController alloc] 
                                              initWithNibName:@"CyworldNoteDeleteArticleViewController" bundle:nil];
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

