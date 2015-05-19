//
//  OAuthInfoManager.h
//  SKPOPSDKDev
//
//  Created by Lion User on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthInfo.h"
#import "OAuthClient.h"


@interface OAuthInfoManager : NSObject
{
    OAuthInfo *oAuthInfo;
    OAuthClient *oAuthClient;

    // OAuth 인증을 통하기 위한. 요구되는 3가지 정보.
    NSString *clientId;
    NSString *clientSecret;
    NSString *scope;
    NSString *code;     // 서버로부터 받는값
    
    NSString *response_type;
    NSString *redirect_uri;
    NSString *grant_type;
    
    NSString *error;
    NSString *errorDesc;
    
    id _target;
    SEL _finishedSelector;
    SEL _failedSelector;
}

@property (nonatomic, retain) OAuthInfo *oAuthInfo;
@property (nonatomic, retain) OAuthClient *oAuthClient;

@property (nonatomic, retain) NSString *clientId;
@property (nonatomic, retain) NSString *clientSecret;
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) NSString *code;

@property (nonatomic, retain) NSString *response_type;
@property (nonatomic, retain) NSString *redirect_uri;
@property (nonatomic, retain) NSString *grant_type;

@property (nonatomic, retain) NSString *error;
@property (nonatomic, retain) NSString *errorDesc;

@property (nonatomic, assign) id _target;
@property (nonatomic, assign) SEL _finishedSelector;
@property (nonatomic, assign) SEL _failedSelector;

+(id)sharedInstance;
-(void)saveOAuthInfo;
-(void)restoreOAuthInfo;
-(void)setOAuthInfo:(OAuthInfo *)oainfo;
-(OAuthInfo *)getOAuthInfo;
-(NSDictionary *)getOAuthInfoDictionary;
-(BOOL)reissueAccessToken;
-(NSString *)getAccessTokenReissueURL;
-(NSString *)getRevokeTokenUrl;
-(void)setOAuthInfoWithJSON:(NSData *)data;
-(void)login:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector;
-(void)logout:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector;
-(void)logout;
-(BOOL)revokeTokenToServer;
-(void)revokeTokenToServerAsynch;

@end
