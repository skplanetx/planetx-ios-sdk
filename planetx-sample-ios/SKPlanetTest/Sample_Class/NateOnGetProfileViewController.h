//
//  NateOnGetProfileViewController.h
//  SKPOPSDKSample
//
//  Created by Lion User on 01/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NateOnGetProfileViewController : UIViewController
{
    IBOutlet UITextView *myTextView;
}
@property (nonatomic, retain) UITextView *myTextView;

- (IBAction)requestSync:(id)sender;
- (IBAction)requestAsync:(id)sender;

@end
