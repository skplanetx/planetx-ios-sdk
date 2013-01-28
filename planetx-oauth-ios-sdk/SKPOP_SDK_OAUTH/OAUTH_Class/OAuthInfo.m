//
//  OAuthInfo.m
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OAuthInfo.h"

@implementation OAuthInfo

@synthesize accessToken, refreshToken, expiresIn, scope, expiresSystime;

static OAuthInfo *sharedInstance = nil;


#pragma mark - Singleton

+(OAuthInfo *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}

#pragma mark

-(NSString *)getWholeInfo
{
    NSString *info = [NSString stringWithFormat:
                     @"accessToken:%@\nrefreshToken:%@\nexpiresIn:%@\nscope:%@\nexpiresSystime:%@\n", 
                     accessToken, refreshToken, expiresIn, scope, expiresSystime
                     ];
    return info;
}

@end
