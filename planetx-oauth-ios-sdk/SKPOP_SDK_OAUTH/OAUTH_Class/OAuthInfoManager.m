//
//  OAuthInfoManager.m
//  SKPOPSDKDev
//
//  Created by Lion User on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OAuthInfoManager.h"
#import "StringUtil.h"
#import "Constants.h"

@implementation OAuthInfoManager


@synthesize oAuthInfo, oAuthClient;
@synthesize clientId, clientSecret, scope, code;
@synthesize response_type, redirect_uri, grant_type;
@synthesize error, errorDesc;

@synthesize _target, _finishedSelector, _failedSelector;

static OAuthInfoManager *sharedInstance = nil;


#pragma mark - Singleton

+(OAuthInfoManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        oAuthInfo = [OAuthInfo sharedInstance];
        oAuthClient = [[OAuthClient alloc] init];
        [self setResponse_type:@"code"];
        [self setRedirect_uri:@"about:blank"];
        [self setGrant_type:@"authorization_code"];
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

-(void)saveOAuthInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:oAuthInfo.accessToken forKey:SKPOP_HEADER_ACCESS_TOKEN];
    [defaults setObject:oAuthInfo.refreshToken forKey:SKPOP_HEADER_REFRESH_TOKEN];
    [defaults setObject:oAuthInfo.expiresIn forKey:SKPOP_OAUTH_END_EXPIRES_IN];
    [defaults setObject:oAuthInfo.scope forKey:SKPOP_OAUTH_END_SCOPE];
    [defaults setObject:oAuthInfo.expiresSystime forKey:SKPOP_OAUTH_EXPIRES_SYSTIME];

    [defaults synchronize];
}

-(void)restoreOAuthInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // 최초에 실행할 때 save하기 전에 restore하면서 메모리 상의 appKey, scope가 사라지는 문제를 막기 위해
    //[oAuthInfo setAppKey:[defaults objectForKey:SKPOP_HEADER_APP_KEY ]];
    [oAuthInfo setAccessToken:[defaults objectForKey:SKPOP_HEADER_ACCESS_TOKEN]];
    [oAuthInfo setRefreshToken:[defaults objectForKey:SKPOP_HEADER_REFRESH_TOKEN]];
    [oAuthInfo setExpiresIn:[defaults objectForKey:SKPOP_OAUTH_END_EXPIRES_IN]];
    //[oAuthInfo setScope:[defaults objectForKey:SKPOP_OAUTH_END_SCOPE]];
    [oAuthInfo setExpiresSystime:[defaults objectForKey:SKPOP_OAUTH_EXPIRES_SYSTIME]];

}

-(void)setOAuthInfo:(OAuthInfo *)oainfo
{
    oAuthInfo.accessToken = [NSString stringWithFormat:@"%@", oainfo.accessToken];
    oAuthInfo.refreshToken = [NSString stringWithFormat:@"%@", oainfo.refreshToken];
    oAuthInfo.expiresIn = [NSString stringWithFormat:@"%@", oainfo.expiresIn];
    oAuthInfo.scope = [NSString stringWithFormat:@"%@", oainfo.scope];
    oAuthInfo.expiresSystime = [NSString stringWithFormat:@"%@", oainfo.expiresSystime];
}

-(OAuthInfo *)getOAuthInfo
{
    OAuthInfo *returnOai = [[OAuthInfo alloc] init];
    returnOai.accessToken = [NSString stringWithFormat:@"%@", oAuthInfo.accessToken];
    returnOai.refreshToken = [NSString stringWithFormat:@"%@", oAuthInfo.refreshToken];
    returnOai.expiresIn = [NSString stringWithFormat:@"%@", oAuthInfo.expiresIn];
    returnOai.scope = [NSString stringWithFormat:@"%@", oAuthInfo.scope];
    returnOai.expiresSystime = [NSString stringWithFormat:@"%@", oAuthInfo.expiresSystime];
    return returnOai;
}

-(NSDictionary *)getOAuthInfoDictionary
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *returnDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [defaults objectForKey:SKPOP_HEADER_APP_KEY ], SKPOP_HEADER_APP_KEY ,
                               [defaults objectForKey:SKPOP_HEADER_ACCESS_TOKEN], SKPOP_HEADER_ACCESS_TOKEN,
                               [defaults objectForKey:SKPOP_HEADER_REFRESH_TOKEN], SKPOP_HEADER_REFRESH_TOKEN,
                                nil];
    
    return returnDic;
}


-(BOOL)reissueAccessToken;
{
    BOOL result = NO;
    NSString *responseString = nil;
    
    NSString *urlAddress = [self getAccessTokenReissueURL];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLResponse* response = nil;
    
#if 0
    // TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
    // SSL 인증 무효화 루틴 추가
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:&response error:nil] ;
    
    responseString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"reissueAccessToken : %@", responseString);
    
    NSRange range = [responseString rangeOfString:@"access_token"];
    if ( range.location != NSNotFound ) {
        [self setOAuthInfoWithJSON:jsonData];
        result = YES;
    }
    
    return result;
}


-(NSString *)getAccessTokenReissueURL
{
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];
    
    NSString *returnURL = [NSString stringWithFormat:
                           @"%@?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                           SKPOP_URL_OAUTH_ACCESS,
                           SKPOP_OAUTH_CLIENT_ID,
                           [oAuthInfoManager.clientId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_CLIENT_SECRET,
                           [oAuthInfoManager.clientSecret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_REDIRECT_URI,
                           [oAuthInfoManager.redirect_uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_GRANT_TYPE,
                           @"refresh_token",
                           SKPOP_OAUTH_SCOPE,
                           [oAuthInfoManager.scope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_REFRESH_TOKEN,
                           [oAuthInfo.refreshToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    NSLog(@"OPEN URL[REFTKN] : %@", returnURL);
    return returnURL;
}

-(NSString *)getRevokeTokenUrl
{
    OAuthInfoManager *oAuthInfoManager = [OAuthInfoManager sharedInstance];
    
    NSString *returnURL = [NSString stringWithFormat:
                           @"%@?%@=%@&%@=%@",
                           SKPOP_URL_OAUTH_REVOKE,
                           SKPOP_OAUTH_CLIENT_ID,
                           [oAuthInfoManager.clientId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                           SKPOP_OAUTH_TOKEN,
                           [oAuthInfo.accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                           ];
    NSLog(@"OPEN URL[RVKTKN] : %@", returnURL);
    return returnURL;
}


-(void)setOAuthInfoWithJSON:(NSData *)data
{
    
    NSError *JSONerror = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &JSONerror];
    if ( JSONerror )
        NSLog(@"Error = %@", JSONerror);
    
    NSString *tmpAccessToken = [NSString stringWithFormat:@"%@", [dict objectForKey:SKPOP_OAUTH_END_ACCESS_TOKEN]];
    if ( tmpAccessToken != nil ) {
        [oAuthInfo setAccessToken:tmpAccessToken];
    }
    
    NSString *tmpRefreshToken = [NSString stringWithFormat:@"%@", [dict objectForKey:SKPOP_OAUTH_END_REFRESH_TOKEN]];
    if ( tmpRefreshToken != nil ) {
        [oAuthInfo setRefreshToken:tmpRefreshToken];
    }
    
    NSString *tmpExpresIn = [NSString stringWithFormat:@"%@", [dict objectForKey:SKPOP_OAUTH_END_EXPIRES_IN]];
    if ( tmpExpresIn != nil ) {
        [oAuthInfo setExpiresIn:tmpExpresIn];
    }
    
    NSString *tmpScope = [NSString stringWithFormat:@"%@", [dict objectForKey:SKPOP_OAUTH_END_SCOPE]];
    if ( tmpScope != nil ) {
        [oAuthInfo setScope:tmpScope];
    }
    
    long long extTime = [oAuthInfo.expiresIn longLongValue];
    NSLog(@"ExtTime : %@", oAuthInfo.expiresIn);
    long long expSTime = [NSDate timeIntervalSinceReferenceDate] * 1000 + extTime * 1000;
    [oAuthInfo setExpiresSystime:[NSString stringWithFormat:@"%lld", expSTime]];
    
    NSLog(@"============OAUTH INFO START=========");
    NSLog(@"%@", oAuthInfo.getWholeInfo);
    NSLog(@"============OAUTH INFO END  =========");
    
    [self saveOAuthInfo];
    
}

/***
 * Access Token의 유효성을 확인하여<br/>
 * Access Token을 그대로 사용할지<br/>
 * Refresh Token을 이용하여 토큰을 갱신(reissue)할지 <br/>
 * Login Dialog를 호출할지를 결정한다.
 */
-(void)login:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector
{
    NSLog(@"============OAUTH INFO START=========");
    NSLog(@"%@", oAuthInfo.getWholeInfo);
    NSLog(@"============OAUTH INFO END  =========");

    // 저장된 정보 복구
    [self restoreOAuthInfo];
    
    NSLog(@"============OAUTH INFO START=========");
    NSLog(@"%@", oAuthInfo.getWholeInfo);
    NSLog(@"============OAUTH INFO END  =========");
    
    // 저장되어 있는 Access Token이 Null 이거나 공백이 아니면.
    if ( oAuthInfo.accessToken != NULL && ! [oAuthInfo.accessToken isEqualToString:@""] ) {
        // Access Token 갱신
        BOOL res = true;
        res = [self reissueAccessToken];
        
        // Refresh Token을 이용하여 Access Token 갱신 실패
        if ( ! res ) {
            // 로그인 Dialog를 띄운다.
            NSLog(@"Token Case 2 : Refresh Token is invalid");
            [oAuthClient login:target finished:finishedSelcotr failed:failedSelector];
        } else {
            // Access Token 갱신에 성공.
            NSLog(@"Token Case 3 : to Success to Refresh Access Token");
        }
    }
    else
    {
        // 저장되어 있는 값이 널이거나 없는 값이면 로그인 창을 띄운다.
        [oAuthClient login:target finished:finishedSelcotr failed:failedSelector];
    }

}


-(void)login
{
    BOOL res = YES;
    res = [self revokeTokenToServer];
}

-(void)logout:(id)target
    finished:(SEL)finishedSelcotr
      failed:(SEL)failedSelector
{
    self._target = target;
    self._finishedSelector = finishedSelcotr;
    self._failedSelector = failedSelector;
    
    [self revokeTokenToServerAsynch];

}

-(void)logout
{
    BOOL res = [self revokeTokenToServer];
    
    if ( res ) {
        NSLog(@"Logout Success");
        [self clearOAuthInfo];
    } else {
        NSLog(@"Logout failed");
    }
}

-(void)clearOAuthInfo
{
    [oAuthInfo setAccessToken:@""];
    [oAuthInfo setRefreshToken:@""];
    [oAuthInfo setExpiresIn:@"0"];
    [self saveOAuthInfo];
}


/***
 * AT RT 파기.
 */
-(BOOL)revokeTokenToServer
{
    BOOL result = NO;
    NSString *responseString = nil;
    
    
    NSString *urlAddress = [self getRevokeTokenUrl];
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLResponse* response = nil;
    
#if 0
    // TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
    // SSL 인증 무효화 루틴 추가
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
#endif
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:&response error:nil] ;
    
    responseString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"revokeTokenToServer : %@", responseString);
    
    NSRange range = [responseString rangeOfString:@"success"];
    if ( range.location != NSNotFound ) {
        result = YES;
    }
    
    return result;
}

-(void)revokeTokenToServerAsynch
{
    NSString *url = [self getRevokeTokenUrl];
    [self readUrl:url];
}

-(void)readUrl:(NSString *)url
{
    
    NSURL *requestUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *err)
     {
         if ([data length] > 0 && err == nil)
         {
             //[receivedData appendData:data];
             
             NSString *result = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
             
             NSString *responseString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
             NSLog(@"revokeTokenToServer : %@", responseString);
             
             if(_target && _finishedSelector)
             {
                 NSRange range = [responseString rangeOfString:@"success"];
                 if ( range.location != NSNotFound ) {
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                     [dict setValue:@"" forKey:SKPopASyncResultCode];
                     [dict setValue:@"" forKey:SKPopASyncResultMessage];
                     [dict setValue:result forKey:SKPopASyncResultData];
                     [_target performSelectorOnMainThread:_finishedSelector withObject:dict waitUntilDone:FALSE];
                     [dict release];
                     [self clearOAuthInfo];
                 } else {
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                     [dict setValue:@"" forKey:SKPopASyncResultCode];
                     [dict setValue:@"" forKey:SKPopASyncResultMessage];
                     [dict setValue:result forKey:SKPopASyncResultData];
                     [_target performSelectorOnMainThread:_failedSelector withObject:dict waitUntilDone:FALSE];
                     [dict release];
                 }
             }

         }
         else if ([data length] == 0 && error == nil)
         {
             NSLog(@"Nothing was downloaded.");
         }
         else if (err != nil){
             NSLog(@"Error = %@", err);
             if(_target && _failedSelector)
             {
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                 [dict setValue:@"" forKey:SKPopASyncResultCode];
                 [dict setValue:[err localizedDescription] forKey:SKPopASyncResultMessage];
                 [dict setValue:@"" forKey:SKPopASyncResultData];
                 [_target performSelectorOnMainThread:_failedSelector withObject:dict waitUntilDone:FALSE];
                 [dict release];
             }
         }
     }];

}

@end
