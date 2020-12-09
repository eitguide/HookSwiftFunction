//
//  HookMaster.m
//  NividHook
//
//  Created by nghianv on 12/7/20.
//

#import "HookMaster.h"
#import <CydiaSubstrate/CydiaSubstrate.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#define NIVID_LOG_FILE @"nivid_log.txt"
typedef void (^CompletionHandler)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface UIView (DisplayName)
+(void)logDisplayName:(NSString*)displayName;
@end

@implementation HookMaster
void (*originSetBackgroundColor)(id class, SEL _cmd, UIColor* color);
void replaceSetBackgroundColor(id class, SEL _cmd, UIColor* color) {
    NSLog(@"setBackgroundColor");
    originSetBackgroundColor(class, _cmd, color);
};

void (*orig_HookSwift_displayName)(id class, SEL _cmd);

void hook_HookSwift_displayName(id class, SEL _cmd) {
    NSLog(@"hook_HookSwift_displayName");
    orig_HookSwift_displayName(class, _cmd);
}

static void __attribute__((constructor)) initialize(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HookMaster loadLib];
    });
}

+ (void)loadLib {
    MSHookFunction(MSFindSymbol(NULL, "_$s9HookSwift10DemoConfigC11displayNameyyF"),
                (void*)hook_HookSwift_displayName,
                (void**)&orig_HookSwift_displayName);
}
@end
