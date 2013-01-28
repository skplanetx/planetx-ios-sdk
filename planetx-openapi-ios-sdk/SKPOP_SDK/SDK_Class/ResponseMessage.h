//
//  ResponseMessage.h
//  SKPOP_SDK
//
//  Created by Ray Cho on 11/15/12.
//
//

#import <Foundation/Foundation.h>

@interface ResponseMessage : NSObject
{
    NSString *statusCode;
    NSString *resultMessage;
}

@property (nonatomic, retain) NSString *statusCode;
@property (nonatomic, retain) NSString *resultMessage;

@end
