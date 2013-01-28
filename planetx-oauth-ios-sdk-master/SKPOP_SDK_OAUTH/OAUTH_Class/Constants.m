//
//  Constants.m
//  SKPOPSDKDev
//
//  Created by Lion User on 28/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"


@implementation Constants

+ (NSString *)getContentType:(SKPopContentType) type 
{
    NSString *contentTypeString = nil;
    
    
    switch (type) {
        case SKPopContentTypeXML :
            contentTypeString = [NSString stringWithFormat:@"application/xml"];
            break;
        case SKPopContentTypeJSON :
            contentTypeString = [NSString stringWithFormat:@"application/json"];
            break;
        case SKPopContentTypeFORM :
            contentTypeString = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
            break;
        case SKPopContentTypeJS :
            contentTypeString = [NSString stringWithFormat:@"application/javascript"];
            break;
        case SKPopContentTypeKML :
            contentTypeString = [NSString stringWithFormat:@"application/vnd.google-earth.kml+xml"];
            break;
        case SKPopContentTypeKMZ :
            contentTypeString = [NSString stringWithFormat:@"application/vnd.google-earth.kmz"];
            break;
        case SKPopContentTypeGEO :
            contentTypeString = [NSString stringWithFormat:@"application/geo+json"];
            break;
        default:
            contentTypeString = [NSString stringWithFormat:@"error"];
            break;
    }
    
    return contentTypeString;
}




@end
