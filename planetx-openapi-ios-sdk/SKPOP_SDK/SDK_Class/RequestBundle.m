//
//  RequestBundle.m
//  SKPOPSDKSample
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RequestBundle.h"

@implementation RequestBundle

@synthesize header, url, parameters, payload;
@synthesize uploadFilePath, uploadFileKey;
@synthesize httpMethod;
@synthesize requestType, responseType;


-(id)init
{
    self = [super init];
    if (self) {
        httpMethod = SKPopHttpMethodGET;
        requestType = SKPopContentTypeJSON;
        responseType = SKPopContentTypeJSON;
        uploadFileKey = @"image";
    }
    return self;
}

- (void)setAppId:(NSString *)appId {
    if ( ! header ) {
        header = [NSMutableDictionary dictionary];
    }
    [header setValue:appId forKey:@"appId"];
}

@end
