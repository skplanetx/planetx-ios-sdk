//
//  APIRequest.m
//  SKPOPSDKSample
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIRequest.h"

#import "OAuthInfo.h"
#import "StringUtil.h"


@implementation APIRequest

@synthesize receivedData, response, result;
@synthesize httpHeader;
@synthesize _target, _finishedSelector, _failedSelector;

NSMutableURLRequest *urlRequest;

static NSString *_appKey;

-(void)dealloc {
    if ( receivedData )
        [receivedData release];
    
    [super dealloc];
}

+(void)setAppKey:(NSString *)appKey
{
    _appKey = appKey;
}

+(NSString*)appKey
{
    return _appKey;
}


-(void)setHeader:(NSError **)error;
{
    OAuthInfo *authinfo = [OAuthInfo sharedInstance];
    
    if ( [APIRequest appKey] == nil ) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:SKPopError00005 forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ERR_CD_00005" code:5 userInfo:details];
        return;
    }
    
    [urlRequest setValue:[APIRequest appKey] forHTTPHeaderField:SKPOP_HEADER_APP_KEY ];
    [urlRequest setValue:authinfo.accessToken forHTTPHeaderField:SKPOP_HEADER_ACCESS_TOKEN];
    [urlRequest setValue:authinfo.refreshToken forHTTPHeaderField:SKPOP_HEADER_REFRESH_TOKEN];
}

-(NSString *)urlConverter:(RequestBundle *)requestBundle {
    
    NSInteger cnt = 0;
    if ( requestBundle.parameters )
        cnt = requestBundle.parameters.count;
    
    NSLog(@"URL : %@", requestBundle.url);
    NSLog(@"paramSize : %d", cnt);
    
    if(cnt == 0){
        return requestBundle.url;
    }

    
    NSString *returnValue = [NSString stringWithFormat:@"%@?%@"
                  , requestBundle.url
                  , [StringUtil getQueryStringFromDictionary:requestBundle.parameters]
                  ];
    
    NSLog(@"ENCODED URL : [%@]", returnValue);
    return returnValue;
}

/***
 * Request Main 제어부
 */
-(void)_request:(RequestBundle *)requestBundle error:(NSError **)error
{

    
    // Request Setup
    // 1. set Url(not null) and set parameters( null value is ok )
    if ( [requestBundle.url isEqualToString:@""] || requestBundle.url == nil ) {
        
        NSLog(@"requestBundle.url : %@", requestBundle.url);
        
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:SKPopError00002 forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ERR_CD_00002" code:2 userInfo:details];
        return;
    }
    
    NSString *encodedUrl = @"";
    
    /*************** Accept / Content Type IS HERE *****************/
    // 2. set up to request payload type and result content type.
    NSString *requestTypeString = [Constants getContentType:requestBundle.requestType];
    NSString *returnTypeString = [Constants getContentType:requestBundle.responseType];
    
    if ( [@"error" isEqualToString:returnTypeString] ) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:SKPopError00003 forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"ERR_CD_00003" code:3 userInfo:details];
        return;
    }
    
    
    
    // 3. set payload data (optional . )
    encodedUrl = [NSString stringWithFormat:@"%@?%@"
                  , requestBundle.url
                  , [StringUtil getQueryStringFromDictionary:requestBundle.parameters]
                  ];
    urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedUrl]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0f];
    
    switch (requestBundle.httpMethod) {
        case SKPopHttpMethodPUT:
            [urlRequest setHTTPMethod:@"PUT"];
            break;
        case SKPopHttpMethodPOST:
            [urlRequest setHTTPMethod:@"POST"];
            break;
        case SKPopHttpMethodGET:
            [urlRequest setHTTPMethod:@"GET"];
            break;
        case SKPopHttpMethodDELETE:
            [urlRequest setHTTPMethod:@"DELETE"];
            break;
        default: {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:SKPopError00001 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"SKPopError" code:1 userInfo:details];
            return;
        }
    }
    
    switch (requestBundle.httpMethod) {
        case SKPopHttpMethodPUT:
        case SKPopHttpMethodPOST:
            // Upload File의 경우 비어 있을 경우 FORM URL ENCODED 형식으로 보낼것인지,
            if ( requestBundle.uploadFilePath == nil || [@"" isEqualToString:requestBundle.uploadFilePath] ) {
                
                NSString *post = nil;
                NSData *postData = nil;
                
                if ( SKPopContentTypeFORM == requestBundle.requestType ) {
                    // CASE : FORM URL ENCODED
                    post = [StringUtil getQueryStringFromDictionary:requestBundle.parameters];
                    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                }
                else
                {
                    // CASE : GENERAL PUT AND POST.
                    postData =[NSMutableData dataWithBytes:[requestBundle.payload UTF8String] length:[requestBundle.payload length]];
                }
                NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
                [urlRequest setValue:requestTypeString forHTTPHeaderField:@"Content-Type"];
                [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
                [urlRequest setHTTPBody:postData];
            }
            else
            {    
               
                NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
                NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
                [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
             
                
                NSMutableData *postData = [NSMutableData data]; 
                
                // Append the file  
                NSData *photo = [[NSFileManager defaultManager] contentsAtPath:requestBundle.uploadFilePath];
                
                NSLog(@"photo size : %d", [photo length]);
                
                [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
                [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [requestBundle uploadFileKey], [requestBundle.uploadFilePath lastPathComponent]]dataUsingEncoding:NSUTF8StringEncoding]];
                [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [postData appendData:[NSData dataWithData:photo]];
                [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postData appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                
                // Close
                [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                
                // Append
                [urlRequest setHTTPBody:postData];
            }
            break;
        case SKPopHttpMethodGET:
        case SKPopHttpMethodDELETE:
            [urlRequest setValue:requestTypeString forHTTPHeaderField:@"Content-Type"];
            break;
        default: {
            NSMutableDictionary* details = [NSMutableDictionary dictionary];
            [details setValue:SKPopError00001 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:@"SKPopError" code:1 userInfo:details];
            return;   
        }
    }
    
    // preset Info to Header
    // 0. Set Init Header Info : OAuth Info Set to Header
    [self setHeader:error];
    if ( ! error ) {
        return;
    }
    [urlRequest setValue:returnTypeString forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"utf-8" forHTTPHeaderField:@"Accept-Encoding"];
    

    
    NSDictionary *headers = [urlRequest allHTTPHeaderFields];
    NSLog(@"HTTPHeaderFields : %@", headers);
    
}

-(ResponseMessage *)request:(RequestBundle *)requestBundle error:(NSError **)error
{
    NSString *resultString = @"";
    NSError *err = nil;
    [self _request:requestBundle error:&err];
    
    if ( err ) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[err localizedDescription] forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:[err domain] code:[err code] userInfo:details];
        return nil;   
    }
    
    NSHTTPURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest 
                                                 returningResponse:&urlResponse 
                                                             error:&err];
    if ( err ) {
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[err localizedDescription] forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"SKPopError" code:1 userInfo:details];
        return nil;      
    }
    
    resultString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"Response data is going to be ==> %@", resultString);

    
    ResponseMessage *responseMessage = [[ResponseMessage alloc] init];
    [responseMessage setStatusCode:[NSString stringWithFormat:@"%d", urlResponse.statusCode]];
    [responseMessage setResultMessage:resultString];
    
    return responseMessage;
}

-(ResponseMessage *)request:(RequestBundle *)requestBundle HTTPMethod:(SKPopHttpMethod)httpMethod error:(NSError **)error;
{
    [requestBundle setHttpMethod:httpMethod];
    return [self request:requestBundle error:error];
}

-(ResponseMessage *)request:(RequestBundle *)requestBundle URL:(NSString *)url HTTPMethod:(SKPopHttpMethod)httpMethod error:(NSError **)error;
{
    [requestBundle setHttpMethod:httpMethod];
    [requestBundle setUrl:url];
    return [self request:requestBundle error:error];
}

-(void)aSyncRequest:(RequestBundle *)requestBundle
{
    
    NSError *err = nil;
    [self _request:requestBundle error:&err];
    
    if ( err ) {
        if(_target && _failedSelector)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:@"" forKey:SKPopASyncResultCode];
            [dict setValue:[err localizedDescription] forKey:SKPopASyncResultMessage];
            [dict setValue:@"" forKey:SKPopASyncResultData];
            [_target performSelectorOnMainThread:_failedSelector withObject:dict waitUntilDone:FALSE];
            [dict release];
        }   
        return;
    }
    
    
    receivedData = [[NSMutableData alloc] init];    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         if (error == nil)
         {
             NSLog(@"APIRequest async data received");
             
             result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
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
         else {
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

-(void)aSyncRequest:(RequestBundle *)requestBundle HTTPMethod:(SKPopHttpMethod)httpMethod
{
    [requestBundle setHttpMethod:httpMethod];
    [self aSyncRequest:requestBundle];
}

-(void)aSyncRequest:(RequestBundle *)requestBundle URL:(NSString*)url HTTPMethod:(SKPopHttpMethod)httpMethod
{
    [requestBundle setHttpMethod:httpMethod];
    [requestBundle setUrl:url];
    [self aSyncRequest:requestBundle];
}


#pragma mark 
-(void)setDelegate:(id)target 
          finished:(SEL)finishedSelcotr 
            failed:(SEL)failedSelector
{   
    self._target = target;
    self._finishedSelector = finishedSelcotr;
    self._failedSelector = failedSelector;
}

@end
