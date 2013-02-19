//
//  HttpHeaders.m
//  SKPOP_SDK_DEV
//
//  Created by Ray Cho on 11/15/12.
//
//

#import "HttpHeaders.h"

@implementation HttpHeaders

@synthesize headerDic;

-(id)init
{
    self = [super init];
    if (self) {
        [self checkInit];
    }
    return self;
}

-(void)dealloc {
    [headerDic release];
    [super dealloc];
}

-(void)checkInit {
    headerDic = [[NSMutableDictionary alloc] init];
}

-(void)put:(NSString *)key Value:(NSString*)value {
    [self checkInit];
    [headerDic setValue:value forKey:key];
}

-(NSString*)get:(NSString *)key {
    return [headerDic objectForKey:key];
}

-(NSMutableDictionary*)getHeader {
    [self checkInit];
    return headerDic;
}

@end
