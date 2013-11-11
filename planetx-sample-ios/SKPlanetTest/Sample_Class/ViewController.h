//
//  ViewController.h
//  SKPlanetTest
//
//  Created by Lion User on 03/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)loginButton:(id)sender;
- (IBAction)getMelonNewSongsButton:(id)sender;
- (IBAction)getElevenStreetCategoriesButton:(id)sender;
- (IBAction)getTcloudImagesButton:(id)sender;
- (IBAction)deleteTcloudImageButton:(id)sender;
- (IBAction)postTcloudImageTagsButton:(id)sender;

-(void)oAuthLoginFinished:(NSDictionary *)result;
-(void)oAuthLoginFailed:(NSDictionary *)result;

@end
