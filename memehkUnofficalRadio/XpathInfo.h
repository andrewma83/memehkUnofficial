//
//  XpathInfo.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlElement.h"

@interface XpathInfo : NSObject
{
    NSMutableDictionary *core;
}

- (id) init;
- (void) insert_string:(NSString *)string
              forXpath:(NSString *)xpath;
- (void) insert_attribute:(NSDictionary *)attribute_dict
                 forXpath:(NSString *)xpath;
- (NSMutableArray *) getXpath:(NSString *)xpath;
@end
