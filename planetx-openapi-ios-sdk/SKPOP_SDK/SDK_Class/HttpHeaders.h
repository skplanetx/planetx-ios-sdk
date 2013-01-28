//
//  HttpHeaders.h
//  SKPOP_SDK_DEV
//
//  Created by Ray Cho on 11/15/12.
//
//

#import <Foundation/Foundation.h>

@interface HttpHeaders : NSObject
{
    NSMutableDictionary* headerDic;
}

@property (nonatomic, retain) NSMutableDictionary* headerDic;

-(void)checkInit;
-(void)put:(NSString *)key Value:(NSString*)value;
-(NSString*)get:(NSString *)key;
-(NSMutableDictionary*)getHeader;

@end
