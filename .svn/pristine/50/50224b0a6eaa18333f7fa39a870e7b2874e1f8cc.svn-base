//
//  ServiceProvider.m
//  YDZF
//
//  Created by zhangliang on 13-10-29.
//  Copyright (c) 2013年 dist. All rights reserved.
//

#import "ServiceProvider.h"
#import "Global.h"

@implementation ServiceProvider

+(ServiceProvider *) initWithDelegate:(id) delegat{
    ServiceProvider *s = [ServiceProvider alloc];
    s.delegate = delegat;
    return s;
}

- (void)getString:(NSString *)type parameters:(NSMutableDictionary *)params{
    requestParameters = params;
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    dataType = 1;
    requestType = type;
    [thread start];
}

- (void)getData:(NSString *)type parameters:(NSMutableDictionary *)params{
    requestParameters = params;
    dataType = 2;
    requestType = type;
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
}

- (void) run{
    NSError *error = nil;
    NSMutableString *requestAddress = [NSMutableString stringWithString:[Global serverAddress]];
    [requestAddress appendFormat:@"?type=%@",requestType];
    
    if (nil!=requestParameters) {
        for (NSString *key in requestParameters.keyEnumerator) {
            NSString *val = [requestParameters objectForKey:key];
            [requestAddress appendFormat:@"&%@=%@",key,[val stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSLog(@"%@",requestAddress);
    
    NSString *theData = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestAddress] encoding:NSUTF8StringEncoding error:&error];
    if (error!=nil) {
        [self performSelectorOnMainThread:@selector(callbackDidFail:) withObject:error waitUntilDone:YES];
    }else{
        if (dataType==1) {
            [self performSelectorOnMainThread:@selector(callbackStringData:) withObject:theData waitUntilDone:YES];
            
        }else if(dataType==2){
            NSData *jsonStringData = [theData dataUsingEncoding:NSUTF8StringEncoding];
            NSError *parseError = nil;
            NSDictionary *rs = [NSJSONSerialization JSONObjectWithData:jsonStringData options:kNilOptions error:&parseError];
            if(nil!=parseError){
                [self performSelectorOnMainThread:@selector(callbackDidFail:) withObject:parseError waitUntilDone:YES];
            }else{
                [self performSelectorOnMainThread:@selector(callbackJsonObject:) withObject:rs waitUntilDone:YES];
            }
        }
        
    }
}

- (void)callbackStringData:(NSString *)data{
    [self.delegate serviceCallback:self didFinishReciveStringData:data];
}

- (void)callbackJsonObject:(NSDictionary *)data{
    [self.delegate serviceCallback:self didFinishReciveJsonData:data];
}

- (void)callbackDidFail:(NSError *)error{
    [self.delegate serviceCallback:self requestFaild:error];
}

@end

