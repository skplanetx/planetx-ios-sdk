//
//  MelonNewSongsViewController.h
//  SKPOPSDKSample
//
//  Created by Lion User on 30/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MelonNewSongsViewController : UIViewController
{
    IBOutlet UITextView *myTextView;
}
@property (nonatomic, retain) UITextView *myTextView;

- (IBAction)requestSync:(id)sender;
- (IBAction)requestAsync:(id)sender;

@end
