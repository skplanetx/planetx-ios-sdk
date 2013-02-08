//
//  CyworldNoteUploadFileViewController.h
//  SKPOPSDKSample
//
//  Created by Lion User on 01/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CyworldNoteUploadFileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UITextView *myTextView;
    IBOutlet UITextField *filePathTextField;
}
@property (nonatomic, retain) UITextView *myTextView;
@property (nonatomic, retain) UITextField *filePathTextField;

- (IBAction)requestSync:(id)sender;
- (IBAction)requestAsync:(id)sender;
- (IBAction)pickImage:(id)sender;

@end
