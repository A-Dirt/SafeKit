//
//  NSString+SafeKit.m
//  SafeKitExample
//
//  Created by zhangyu on 14-3-15.
//  Copyright (c) 2014年 zhangyu. All rights reserved.
//

#import "NSString+SafeKit.h"
#import "NSObject+swizzle.h"

@implementation NSString (SafeKit)

- (unichar)safe_characterAtIndex:(NSUInteger)index {
    if (index >= [self length]) {
        return 0;
    }
    return [self safe_characterAtIndex:index];
}

- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        return @"";
    }
    return [self safe_substringWithRange:range];
}

- (NSString *)safe_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    if (!target) {
        return self;
    }
    if (!replacement) {
        return self;
    }
    if (!options) {
        options = NSWidthInsensitiveSearch;
    }
    if (searchRange.location >= [self length]) {
        return [self safe_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(self.length , 0)];
    }
    if (searchRange.location + searchRange.length >= [self length]) {
        return [self safe_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(searchRange.location, self.length - searchRange.location)];
    }
    return [self safe_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
}

- (NSString *)safe_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    if (range.location >= [self length]) {
        range = NSMakeRange(self.length, 0);
    } else if (range.location + range.length >= [self length]) {
        range = NSMakeRange(range.location, [self length] - range.location);
    }
    if (!replacement) {
        replacement = @"";
    }
    return [self safe_stringByReplacingCharactersInRange:range withString:replacement];
}

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_swizzleMethod:@selector(safe_characterAtIndex:) tarClass:@"__NSCFString" tarSel:@selector(characterAtIndex:)];
        [self safe_swizzleMethod:@selector(safe_substringWithRange:) tarClass:@"__NSCFString" tarSel:@selector(substringWithRange:)];
        [self safe_swizzleMethod:@selector(safe_stringByReplacingOccurrencesOfString:withString:options:range:) tarClass:@"__NSCFString" tarSel:@selector(stringByReplacingOccurrencesOfString:withString:options:range:)];
        [self safe_swizzleMethod:@selector(safe_stringByReplacingCharactersInRange:withString:) tarClass:@"__NSCFString" tarSel:@selector(stringByReplacingCharactersInRange:withString:)];
    });
}

@end
