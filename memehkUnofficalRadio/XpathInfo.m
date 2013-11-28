//
//  XpathInfo.m
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import "XpathInfo.h"
#import "XmlElement.h"

@interface XpathInfo ()
- (void)create_xpath_key:(NSString *)xpath;
@end

@implementation XpathInfo

- (id) init
{
    self = [super init];
    core = [[NSMutableDictionary alloc] init];
    return self;
}

- (void) create_xpath_key:(NSString *)xpath
{
    NSMutableArray *array;
    
    array = [core objectForKey:xpath];
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
        [core setObject:array forKey:xpath];
    }
}

- (void) insert_attribute:(NSDictionary *)attribute_dict
                 forXpath:(NSString *)xpath
{
    NSMutableArray *array;
    XmlElement *element;
    
    [self create_xpath_key:xpath];
    array = [core objectForKey:xpath];
    
    element = [[XmlElement alloc] init];
    element.attributeDict = attribute_dict;
    [array addObject:element];
}

- (void) insert_string:(NSString *)string
              forXpath:(NSString *)xpath
{
    NSMutableArray *array;
    XmlElement *element;
    
    [self create_xpath_key:xpath];
    array = [core objectForKey:xpath];
    element =  array.lastObject;
    
    element.value = string;
}

- (NSMutableArray *) getXpath:(NSString *)xpath
{
    NSMutableArray *array;
    
    array = [core objectForKey:xpath];
    return array;
}
@end
