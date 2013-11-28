//
//  RSSParser.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XpathInfo.h"

@interface RSSParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray *xpath_array;
    NSXMLParser *xmlparser;    
    XpathInfo *path_dict;
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict;

- (void) parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string;

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName;


- (id) init:(NSData *) data;
- (XpathInfo *) parse;


@end
