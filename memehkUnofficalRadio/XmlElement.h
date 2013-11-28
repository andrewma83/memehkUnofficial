//
//  XmlElement.h
//  memehkUnofficalRadio
//
//  Created by Andrew Ma on 11/27/13.
//  Copyright (c) 2013 Andrew Ma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlElement : NSObject
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSDictionary *attributeDict;
- (id) init;
@end
