//
//  TcloudImagesDeleteViewController.h
//  SKPlanetTest
//
//  Created by Ray on 13. 11. 10..
//
//

#import <UIKit/UIKit.h>

@interface TcloudImagesDeleteViewController : UIViewController
{
    IBOutlet UITextView *myTextView;
}
@property (nonatomic, retain) UITextView *myTextView;

- (IBAction)requestSync:(id)sender;
- (IBAction)requestAsync:(id)sender;

@end
