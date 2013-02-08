//
//  OAuthClient.h
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OAuthClient : UIViewController <UIWebViewDelegate>
{
    UIWebView *loginView;
    UIView *viewBlock;
    UIView *bgView;
    
    NSMutableData *receivedData;
    NSURLResponse *response;
    NSString *result;
    id _target;
    SEL _finishedSelector;
    SEL _failedSelector;
}

@property (nonatomic, retain) UIWebView *loginView;
@property (nonatomic, retain) UIView *viewBlock;
@property (nonatomic, retain) UIView *bgView;

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, assign) id _target;
@property (nonatomic, assign) SEL _finishedSelector;
@property (nonatomic, assign) SEL _failedSelector;

-(void)login:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector;
-(void)closeLoginView;
-(NSString *)getOAuthorizationUrl;
-(NSString *)getOAccessTokenUrl;
-(void)animationDidStop:(NSString *)animID finished:(BOOL)didFinish context:(void *)context;
@end
