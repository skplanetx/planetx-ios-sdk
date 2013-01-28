//
//  OAuthInfo.h
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthInfo : NSObject
{
    NSString *accessToken;
    NSString *refreshToken; 
    NSString *expiresIn;
    NSString *scope;
    NSString *expiresSystime;
}

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *expiresIn;
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) NSString *expiresSystime;

+(id)sharedInstance;
-(NSString *)getWholeInfo;

@end
