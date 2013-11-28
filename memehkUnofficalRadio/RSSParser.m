//
//  RSSParser.m
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import "RSSParser.h"
@interface RSSParser ()
- (NSString *) create_xpath;
@end

@implementation RSSParser

- (id) init:(NSData *) data
{
    xpath_array = [[NSMutableArray alloc] init];
    xmlparser = [[NSXMLParser alloc] initWithData:data];
    [xmlparser setDelegate:self];
    path_dict = [[XpathInfo alloc] init];
    return self;
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict
{
    NSString *xpath;
    
    [xpath_array addObject:elementName];
    xpath = [self create_xpath];
    [path_dict insert_attribute:attributeDict
                       forXpath:xpath];
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName;
{
    [xpath_array removeLastObject];
}

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string;
{
    NSString *xpath;
    
    xpath = [self create_xpath];
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0) {
        [path_dict insert_string:string forXpath:xpath];
    }
}

- (XpathInfo *) parse
{
    [xmlparser parse];
    return path_dict;
}

- (NSString *) create_xpath
{
    NSString *element = nil;
    NSMutableString *xpath = [[NSMutableString alloc] initWithString:@"/"];
    
    for (element in xpath_array) {
        [xpath appendString:@"/"];
        [xpath appendString:element];
    }
    
    return xpath;
}


@end
