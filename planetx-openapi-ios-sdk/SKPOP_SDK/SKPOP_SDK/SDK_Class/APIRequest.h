//
//  APIRequest.h
//  SKPOPSDKSample
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "RequestBundle.h"
#import "ResponseMessage.h"
#import "HttpHeaders.h"

@interface APIRequest : NSObject
{
    NSMutableData *receivedData;
    NSURLResponse *response;
    NSString *result;
    
    HttpHeaders *httpHeader;
    
    id _target;
    SEL _finishedSelector;
    SEL _failedSelector;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) HttpHeaders *httpHeader;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, assign) id _target;
@property (nonatomic, assign) SEL _finishedSelector;
@property (nonatomic, assign) SEL _failedSelector;

+(void)setAppKey:(NSString *)appKey;
+(NSString *)appKey;

-(void)setHeader:(NSError **)error;

-(NSString *)urlConverter:(RequestBundle *)requestBundle;
-(ResponseMessage *)request:(RequestBundle *)requestBundle error:(NSError **)error;
-(ResponseMessage *)request:(RequestBundle *)requestBundle HTTPMethod:(SKPopHttpMethod)httpMethod error:(NSError **)error;
-(ResponseMessage *)request:(RequestBundle *)requestBundle URL:(NSString*)url HTTPMethod:(SKPopHttpMethod)httpMethod error:(NSError **)error;

-(void)aSyncRequest:(RequestBundle *)requestBundle;
-(void)aSyncRequest:(RequestBundle *)requestBundle HTTPMethod:(SKPopHttpMethod)httpMethod ;
-(void)aSyncRequest:(RequestBundle *)requestBundle URL:(NSString*)url HTTPMethod:(SKPopHttpMethod)httpMethod ;
-(void)setDelegate:(id)target
          finished:(SEL)finishedSelcotr 
            failed:(SEL)failedSelector;

@end
