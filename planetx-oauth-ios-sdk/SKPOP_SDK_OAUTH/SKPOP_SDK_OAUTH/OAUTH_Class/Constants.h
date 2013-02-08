//
//  Constants.h
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const SKPOP_HEADER_APP_KEY  = @"appKey";
static NSString *const SKPOP_HEADER_ACCESS_TOKEN = @"access_token";
static NSString *const SKPOP_HEADER_REFRESH_TOKEN = @"refresh_token";

// OAUTH ONLY : STEP 1 AUTHORIZATION
static NSString *const SKPOP_OAUTH_CLIENT_ID = @"client_id";
static NSString *const SKPOP_OAUTH_RESPONSE_TYPE = @"response_type"; // VALUE : code
static NSString *const SKPOP_OAUTH_SCOPE = @"scope";
static NSString *const SKPOP_OAUTH_REDIRECT_URI = @"redirect_uri"; // VALUE :
// OAUTH ONLY : STEP 2 ACCESSTOKEN
static NSString *const SKPOP_OAUTH_CLIENT_SECRET = @"client_secret";
static NSString *const SKPOP_OAUTH_CODE = @"code"; // 인증 Endpoint에서 받은 
// Authorization code
static NSString *const SKPOP_OAUTH_GRANT_TYPE = @"grant_type"; // VALUE : authorization_code

// OAUTH ONLY : REFRESH TOKEN
static NSString *const SKPOP_OAUTH_REFRESH_TOKEN 	= @"refresh_token";

// OAUTH ONLY : REVOKE TOKEN
static NSString *const SKPOP_OAUTH_TOKEN 	= @"token";

static NSString *const SKPOP_OAUTH_END_ACCESS_TOKEN 	= @"access_token";
static NSString *const SKPOP_OAUTH_END_REFRESH_TOKEN 	= @"refresh_token";
static NSString *const SKPOP_OAUTH_END_EXPIRES_IN 		= @"expires_in";
static NSString *const SKPOP_OAUTH_END_SCOPE 			= @"scope";
static NSString *const SKPOP_OAUTH_EXPIRES_SYSTIME	= @"expires_systime";

#define SKPOP_URL_OAUTH_SERVER @"https://oneid.skplanetx.com"
#define SKPOP_URL_OAUTH_AUTHEN SKPOP_URL_OAUTH_SERVER"/oauth/authorize"
#define SKPOP_URL_OAUTH_ACCESS SKPOP_URL_OAUTH_SERVER"/oauth/token"
#define SKPOP_URL_OAUTH_REVOKE SKPOP_URL_OAUTH_SERVER"/oauth/expireToken"


typedef enum {
    SKPopContentTypeXML
    , SKPopContentTypeJSON
    , SKPopContentTypeFORM
    , SKPopContentTypeJS
    , SKPopContentTypeKML
    , SKPopContentTypeKMZ
    , SKPopContentTypeGEO
} SKPopContentType;

typedef enum {
    SKPopHttpMethodPUT
    , SKPopHttpMethodPOST
    , SKPopHttpMethodGET
    , SKPopHttpMethodDELETE
} SKPopHttpMethod;

static NSString *const SKPopError00001 = @"HttpMethod is null";
static NSString *const SKPopError00002 = @"Url is null or empty";
static NSString *const SKPopError00003 = @"ReturnType-value is wrong";
static NSString *const SKPopError00004 = @"ASynchronous Listener is null" ;
static NSString *const SKPopError00005 = @"Header infomation is null";     
static NSString *const SKPopError00006 = @"Application Key is null or empty";       
static NSString *const SKPopError00007 = @"Context is null."; 
static NSString *const SKPopError00008 = @"Recived data is empty.";

// ASync 용
#define SKPopASyncResultCode @"RC"
#define SKPopASyncResultMessage @"RM"
#define SKPopASyncResultData @"RD"

@interface Constants : NSObject

+ (NSString *)getContentType:(SKPopContentType) type;

@end

#if 0
// TODO FIXME 중요!! 무효화 루틴 상용 배포시 반드시 제거할것.!!!!!!!!!!
// SSL 인증 무효화 루틴 추가
@interface NSURLRequest (DummyInterface)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end
#endif

