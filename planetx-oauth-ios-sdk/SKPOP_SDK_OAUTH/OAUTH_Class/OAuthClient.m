//
//  OAuthClient.m
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OAuthClient.h"
#import "StringUtil.h"
#import "OAuthInfoManager.h"
#import "Constants.h"

@interface OAuthClient ()

@end


@implementation OAuthClient

@synthesize loginView, viewBlock, bgView;
@synthesize receivedData, response, result;
@synthesize _target, _finishedSelector, _failedSelector;

CGRect oldStatusFrame;

-(id)init
{
    self = [super init];
    if (self) {    
        //
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

-(void)login:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector
{
    self._target = target;
    self._finishedSelector = finishedSelcotr;
    self._failedSelector = failedSelector;
    
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    oldStatusFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    [[UIApplication sharedApplication]
        setStatusBarHidden:YES
        withAnimation:UIStatusBarAnimationNone];

    
    CGRect fullFrame = window.bounds;
    CGFloat w, h, x, y;
    
    w = fullFrame.size.width;
    h = fullFrame.size.height;
    x = fullFrame.origin.x;
    y = fullFrame.origin.y;
    
	viewBlock = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, w, h)];
    [viewBlock setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [viewBlock setAutoresizesSubviews:YES];
    [viewBlock setBackgroundColor:[UIColor clearColor]];
	[window addSubview:viewBlock];
	[viewBlock release];
    
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(w/2, h/2, 0, 0)];
    [bgView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [bgView setAutoresizesSubviews:YES];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:0.7]];
    bgView.layer.cornerRadius = 10;
    bgView.clipsToBounds = YES;
    
    [viewBlock addSubview:bgView];
    [bgView release];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton 
        addTarget:self
        action:@selector(closeLoginView) 
        forControlEvents:(UIControlEvents)UIControlEventTouchUpInside];
    [closeButton setFrame:CGRectMake(w-40, 5, 20, 20)];
    [bgView addSubview:closeButton];

    
    loginView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, w-10, h-10-30)];
    [loginView setDelegate:self];
    [loginView setBackgroundColor:[UIColor clearColor]];
    [loginView setScalesPageToFit:YES];
    [bgView addSubview:loginView];
    [loginView release];
    
    [UIView beginAnimations:@"oAuthLoginBoxPopup" context:closeButton];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [bgView setFrame:CGRectMake(x+5, 5, w-10, h-10)];
    [UIView commitAnimations];
    
    NSString *urlAddress = [self getOAuthorizationUrl];
    NSURL *url = [NSURL URLWithString:urlAddress];
#if 0
    // TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
    // SSL 인증 무효화 루틴 추가
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [loginView loadRequest:requestObj];       
    
}

-(void)closeLoginView
{
    CGFloat w, h;
    
    w = bgView.frame.size.width;
    h = bgView.frame.size.height;
    
    [UIView beginAnimations:@"close" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.5];
    [bgView setFrame:CGRectMake(w/2, h/2, 0, 0)];    
    [UIView commitAnimations];
}
     
-(void)animationDidStop:(NSString *)animID finished:(BOOL)didFinish context:(void *)context
{
    if ( [animID isEqualToString:@"oAuthLoginBoxPopup"] ) {
        UIButton *closeButton = context;
        CGRect fullFrame = [[UIApplication sharedApplication] keyWindow].bounds;
        CGFloat w, h;
        
        w = fullFrame.size.width;
        h = fullFrame.size.height;
        
        [closeButton setFrame:CGRectMake(w-40, 5, 20, 20)];
        [loginView setFrame:CGRectMake(0, 30, w-10, h-10-30)];

        [closeButton setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin)];
        [loginView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];

    }
    if ( [animID isEqualToString:@"close"] ) {
        [loginView removeFromSuperview];
        [bgView removeFromSuperview];
        [viewBlock removeFromSuperview];
        
        if ( oldStatusFrame.size.height > 0 ) {
            [[UIApplication sharedApplication]
             setStatusBarHidden:NO
             withAnimation:UIStatusBarAnimationNone];
        }
    }
}

-(NSString *)getOAuthorizationUrl
{
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];
    
    NSString *returnURL = [NSString stringWithFormat:
                           @"%@?%@=%@&%@=%@&%@=%@&%@=%@",
                           SKPOP_URL_OAUTH_AUTHEN,
                           SKPOP_OAUTH_CLIENT_ID, 
                           [oAuthInfoManager.clientId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_RESPONSE_TYPE, 
                           [oAuthInfoManager.response_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_SCOPE, 
                           [oAuthInfoManager.scope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
                           SKPOP_OAUTH_REDIRECT_URI, 
                           [oAuthInfoManager.redirect_uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    NSLog(@"OPEN URL[AUTH] : %@", returnURL);
    return returnURL;
}

-(NSString *)getOAccessTokenUrl
{
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];

    NSString *returnURL = [NSString stringWithFormat:
                           @"%@?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                           SKPOP_URL_OAUTH_ACCESS,
                           SKPOP_OAUTH_CLIENT_ID, 
                           [oAuthInfoManager.clientId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_SCOPE, 
                           [oAuthInfoManager.scope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_REDIRECT_URI, 
                           [oAuthInfoManager.redirect_uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_CLIENT_SECRET, 
                           [oAuthInfoManager.clientSecret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_CODE, 
                           [oAuthInfoManager.code stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_GRANT_TYPE, 
                           [oAuthInfoManager.grant_type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    return returnURL;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestStr = [[request URL] absoluteString];
    NSLog(@"shouldStartLoadWithRequest : %@", requestStr);
    if ( [[requestStr substringToIndex:8] compare:@"oauths://" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        NSRange range = NSMakeRange(9, [requestStr length] - 9);
        requestStr = [NSString stringWithFormat:@"%@%@", @"https://", [requestStr substringWithRange:range]];
        NSLog(@"shouldStartLoadWithRequest : %@", requestStr);
        NSURL *url = [NSURL URLWithString:requestStr];
#if 0
        // TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
        // SSL 인증 무효화 루틴 추가
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [loginView loadRequest:requestObj];
        return NO;
    } else
    if ( [[requestStr substringToIndex:7] compare:@"oauth://" options:NSCaseInsensitiveSearch] == NSOrderedSame )
    {
        NSRange range = NSMakeRange(8, [requestStr length] - 8);
        requestStr = [NSString stringWithFormat:@"%@%@", @"http://", [requestStr substringWithRange:range]];
        NSLog(@"shouldStartLoadWithRequest : %@", requestStr);
        
        NSURL *url = [NSURL URLWithString:requestStr];
#if 0
        // TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
        // SSL 인증 무효화 루틴 추가
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [loginView loadRequest:requestObj];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError %@ %@", error, [error userInfo]);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];

    NSString *urlStr = [webView.request.URL absoluteString];
    
    NSRange range = [urlStr rangeOfString:@"access_complete_mobile"];
    if ( range.length > 0 ) { // 처리 완료 페이지 일 때
        [oAuthInfoManager setCode:[StringUtil getValueFromQueryString:urlStr Key:@"code"]];
        [self readUrl:[self getOAccessTokenUrl]];
    }
    
    NSRange range1 = [urlStr rangeOfString:@"error_description"];
    if ( range1.length > 0 ) { // 에러 상황 일 때
        NSString *err = [StringUtil getValueFromQueryString:urlStr Key:@"error"];
        NSString *desc = [StringUtil getValueFromQueryString:urlStr Key:@"error_description"];

        [oAuthInfoManager setError:[StringUtil getValueFromQueryString:urlStr Key:err]];
        [oAuthInfoManager setErrorDesc:desc];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SKPop" message:desc delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)readUrl:(NSString *)url
{
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
        {
            
            result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            [self parseData:data];
            if(_target && _finishedSelector)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"" forKey:SKPopASyncResultCode];
                [dict setValue:@"" forKey:SKPopASyncResultMessage];
                [dict setValue:result forKey:SKPopASyncResultData];
                [_target performSelectorOnMainThread:_finishedSelector withObject:dict waitUntilDone:FALSE];
                [dict release];
            }
        }
        else if ([data length] == 0 && error == nil)
        {
            NSLog(@"Nothing was downloaded.");
        }
        else if (error != nil){
            NSLog(@"Error = %@", error);
            if(_target && _failedSelector)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"" forKey:SKPopASyncResultCode];
                [dict setValue:[error localizedDescription] forKey:SKPopASyncResultMessage];
                [dict setValue:@"" forKey:SKPopASyncResultData];
                [_target performSelectorOnMainThread:_failedSelector withObject:dict waitUntilDone:FALSE];
                [dict release];
            
            }
        }
    }];


}

-(void)parseData:(NSData *)data
{   
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];

    NSLog(@"accessToken : %@", oAuthInfoManager.oAuthInfo.accessToken);
    NSError *JSONerror = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONerror];
    if ( JSONerror )
        NSLog(@"Error = %@", JSONerror);
    
    NSString *access_token = [NSString stringWithFormat:@"%@", [dict objectForKey:@"access_token"]];
    if ( access_token != nil ) {
        [oAuthInfoManager.oAuthInfo setAccessToken:access_token];
    }
    
    NSLog(@"accessToken : %@", oAuthInfoManager.oAuthInfo.accessToken);
    
    NSString *refresh_token = [NSString stringWithFormat:@"%@", [dict objectForKey:@"refresh_token"]];
    if ( refresh_token != nil ) {
        [oAuthInfoManager.oAuthInfo setRefreshToken:refresh_token];
    }
    
    NSString *expires_in = [NSString stringWithFormat:@"%@", [dict objectForKey:@"expires_in"]];
    if ( expires_in != nil ) {
        [oAuthInfoManager.oAuthInfo setExpiresIn:expires_in];
    }
    
    NSString *scope = [NSString stringWithFormat:@"%@", [dict objectForKey:@"scope"]];
    if ( scope != nil ) {
        [oAuthInfoManager.oAuthInfo setScope:scope];
    }
    
    long long extTime = [oAuthInfoManager.oAuthInfo.expiresIn longLongValue];
    NSLog(@"ExtTime : %@", oAuthInfoManager.oAuthInfo.expiresIn);
    long long expSTime = [NSDate timeIntervalSinceReferenceDate] * 1000 + extTime * 1000;
    [oAuthInfoManager.oAuthInfo setExpiresSystime:[NSString stringWithFormat:@"%lld", expSTime]];

    [oAuthInfoManager saveOAuthInfo];
    
    NSLog(@"============OAUTH INFO START=========");
    NSLog(@"%@", oAuthInfoManager.oAuthInfo.getWholeInfo);
    NSLog(@"============OAUTH INFO END  =========");
    
    [self performSelectorOnMainThread:@selector(closeLoginView) withObject:nil waitUntilDone:FALSE];
    
}


@end
