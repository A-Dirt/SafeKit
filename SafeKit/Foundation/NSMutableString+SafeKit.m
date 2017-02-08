//
//  NSMutableString+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSMutableString+SafeKit.h"
#import "NSObject+swizzle.h"
#import "SafeKitMacro.h"

@implementation NSMutableString (SafeKit)

- (void)safe_appendString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self safe_appendString:aString];
}

- (void)safe_appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
    if (!format) {
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    formatStr = SK_AUTORELEASE(formatStr);
    [self safe_appendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)safe_setString:(NSString *)aString {
    if (!aString) {
        return;
    }
    [self safe_setString:aString];
}

- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)index {
    if (index > [self length]) {
        return;
    }
    if (!aString) {
        return;
    }
    
    [self safe_insertString:aString atIndex:index];
}

- (NSUInteger)safe_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    if (!target) {
        return 0;
    }
    if (!replacement) {
        return 0;
    }
    if (!options) {
        options = NSWidthInsensitiveSearch;
    }
    if (searchRange.location >= [self length]) {
        searchRange = NSMakeRange(self.length, 0);
    } else if (searchRange.location + searchRange.length >= [self length]) {
        searchRange = NSMakeRange(searchRange.location, [self length] - searchRange.location);
    }
    return [self safe_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
}

- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    if (range.location >= [self length]) {
        range = NSMakeRange(self.length, 0);
    } else if (range.location + range.length >= [self length]) {
        range = NSMakeRange(range.location, [self length] - range.location);
    }
    if (!aString) {
        aString = @"";
    }
    return [self safe_replaceCharactersInRange:range withString:aString];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_swizzleMethod:@selector(safe_appendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
        [self safe_swizzleMethod:@selector(safe_appendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
        [self safe_swizzleMethod:@selector(safe_setString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
        [self safe_swizzleMethod:@selector(safe_insertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
        [self safe_swizzleMethod:@selector(safe_replaceOccurrencesOfString:withString:options:range:) tarClass:@"__NSCFConstantString" tarSel:@selector(replaceOccurrencesOfString:withString:options:range:)];
        [self safe_swizzleMethod:@selector(safe_replaceCharactersInRange:withString:) tarClass:@"__NSCFConstantString" tarSel:@selector(replaceCharactersInRange:withString:)];
    });
}

@end
