//
//  RequestBundle.h
//  SKPOPSDKSample
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"


@interface RequestBundle : NSObject
{
    /***
     * Request시에 기본으로 실리는 데이터들.<br>
     * app id 및 oauth 정보가 실리게된다.
     */
    NSDictionary *header;
    
    /***
     * OPEN API URL
     */
    NSString *url;
    /***
     * PathParam , QueryString, FormEncoded(Key, Value)
     */
    NSDictionary *parameters;
    /***
     * ContentBody부분에 삽입되는 데이터(XML JSON FORM ~), RequestType과 일치해야함.
     */
    NSString *payload;
    /***
     * File Upload시에 사용
     */
    NSString *uploadFilePath;
    /***
     * File Upload Key에 사용
     */
    NSString *uploadFileKey;
    /***
     * put post get delete
     */
    SKPopHttpMethod httpMethod;
    /***
     * Request시에 Payload에 실리는 Content Type
     */
    SKPopContentType requestType;
    /***
     * Response Content Type
     */
    SKPopContentType responseType;
    /***
     * 비동기 통신에 사용하는 리스너
     */
    //private RequestListener requestListener;    
}

@property (nonatomic, retain) NSDictionary *header;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDictionary *parameters;
@property (nonatomic, retain) NSString *payload;
@property (nonatomic, retain) NSString *uploadFilePath;
@property (nonatomic, retain) NSString *uploadFileKey;
@property SKPopHttpMethod httpMethod;
@property SKPopContentType requestType;
@property SKPopContentType responseType;

- (void)setAppId:(NSString *)appId;

@end
