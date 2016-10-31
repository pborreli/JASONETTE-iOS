//
//  JasonSessionAction.m
//  Jasonette
//
//  Copyright © 2016 gliechtenstein. All rights reserved.
//
#import "JasonSessionAction.h"

@implementation JasonSessionAction
- (void)set{
    NSString *url = self.options[@"url"];
    NSString *domain = nil;
    if(url){
        domain = [[[NSURL URLWithString:[JasonHelper prependProtocolToUrl:self.options[@"url"]]] host] lowercaseString];
    } else {
        domain = [[[NSURL URLWithString:[JasonHelper prependProtocolToUrl:self.options[@"domain"]]] host] lowercaseString];
    }
    

    
    if(domain){
        NSDictionary *header = self.options[@"header"];
        NSDictionary *body = self.options[@"body"];
        NSMutableDictionary *session = [[NSMutableDictionary alloc] init];
        session[@"domain"] = domain;
        session[@"url"] = url;
        if(header){
            session[@"header"] = header;
        }
        if(body){
            session[@"body"] = body;
        }
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:[domain lowercaseString]];
        keychain[@"session"] = [session description];
        
        [[Jason client] success];
        return;
    }
    
    [[Jason client] error];
}
- (void)reset{
    if(self.options){
        if(self.options[@"type"] && [self.options[@"type"] isEqualToString:@"html"]){
            NSString *url = self.options[@"url"];
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
            for (NSHTTPCookie *cookie in cookies)
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: cookiesData forKey: @"sessionCookies"];
            [defaults synchronize];
            [[Jason client] success];
        } else {
                    
            NSString *url = self.options[@"url"];
            NSString *domain = nil;
            if(url){
                domain = [[[NSURL URLWithString:[JasonHelper prependProtocolToUrl:self.options[@"url"]]] host] lowercaseString];
            } else {
                domain = [[[NSURL URLWithString:[JasonHelper prependProtocolToUrl:self.options[@"domain"]]] host] lowercaseString];
            }
    
            UICKeyChainStore* keychain = [UICKeyChainStore keyChainStoreWithService:domain];
            [keychain removeAllItems];
            [[Jason client] success];
        }
    }
    
}
@end
