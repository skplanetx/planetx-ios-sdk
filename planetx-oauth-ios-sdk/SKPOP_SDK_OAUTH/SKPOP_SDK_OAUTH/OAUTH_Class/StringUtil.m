//
//  StringUtil.m
//  SKPOPSDKDev
//
//  Created by Lion User on 29/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StringUtil.h"


@implementation StringUtil


NSString * escapeString(NSString *string) 
{
    NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                      (CFStringRef)string,
                                                                      NULL,
                                                                      (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                      kCFStringEncodingUTF8);
    return [s autorelease];
}

+(NSString *)getValueFromQueryString:(NSString *)str Key:(NSString *)key
{
    NSString *findStr;
    NSString *targetStr;
    NSString *returnStr;
    NSRange range;
    
    findStr = [NSString stringWithFormat:@"%@=", key];
    range = [str rangeOfString:findStr];
    
    if ( range.length < 1 ) return nil;
    
    targetStr = [str substringFromIndex:range.location];
    
    range = [targetStr rangeOfString:@"&"];
    if ( range.length < 1 ) {
        returnStr = [targetStr substringFromIndex:[findStr length]];
    } else {
        returnStr = [targetStr substringWithRange:NSMakeRange([findStr length], range.location-[findStr length])];
    }
    
    return returnStr;
}


+(NSString *)getQueryStringFromDictionary:(NSDictionary *)dict
{
    NSMutableString *queryString = nil;
    NSArray *keys = [dict allKeys];
    
    if ([keys count] > 0) {
        for (id key in keys) {
            id value = [dict objectForKey:key];
            if (nil == queryString) {
                queryString = [[[NSMutableString alloc] init] autorelease];
                //[queryString appendFormat:@"?"]; // POST 방식에서도 쓰기 위해 
            } else {
                [queryString appendFormat:@"&"];
            }
            
            if (nil != key && nil != value) {
                [queryString appendFormat:@"%@=%@", escapeString(key), escapeString(value)];
            } else if (nil != key) {
                [queryString appendFormat:@"%@", escapeString(key)];
            }
        }
    }    
    return queryString;
}

@end
