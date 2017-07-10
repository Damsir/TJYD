//
//  DigitMaterialModel.m
//  XAYD
//
//  Created by songdan Ye on 16/1/19.
//  Copyright © 2016年 dist. All rights reserved.
//

#import "DigitMaterialModel.h"

@implementation DigitMaterialModel
// "name": "公文资料",
//"creationTime": "2015-11-24 16:30:25",
//"extension": "",
//"byname": "",
//"type": "directory"
//},
- (instancetype) initWithDict:(NSDictionary *)dict
{
    if (self=[super init]) {
    self.name = [dict objectForKey:@"name"];
    self.creationTime = [dict objectForKey:@"creationTime"];
        self.extension = [dict objectForKey:@"extension"];
        self.byname = [dict objectForKey:@"byname"];
        self.type = [dict objectForKey:@"type"];

    
}
    return self;
}


+(instancetype) digitMaterialModelWithDict:(NSDictionary *)dict
{
    return  [[self alloc] initWithDict:dict];
 
}

@end
