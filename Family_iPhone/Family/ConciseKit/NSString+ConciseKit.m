#import "NSString+ConciseKit.h"

@implementation NSString (ConciseKit)

- (NSString *)$append:(NSString *)aString {
  return [self stringByAppendingString:aString];
}

- (NSString *)$prepend:(NSString *)aString {
  return [NSString stringWithFormat:@"%@%@", aString, self];
}

- (NSArray *)$split:(NSString *)aString {
  return [self componentsSeparatedByString:aString];
}

- (NSArray *)$split {
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//为又拍设置，因为有些url后面有!320x100这样的
- (NSString *)delLastStrForYouPai {
    NSRange theRange = [self rangeOfString:@"!"];
    if (theRange.length > 0) {
        theRange.length = self.length - theRange.location;
        NSString *afterStr = [self stringByReplacingCharactersInRange:theRange withString:@""];
        return afterStr;
    }
    return self;
}

@end

@implementation NSMutableString (ConciseKit)

- (NSMutableString *)$append_:(NSString *)aString {
  [self appendString:aString];
  return self;
}

- (NSMutableString *)$prepend_:(NSString *)aString {
  [self insertString:aString atIndex:0];
  return self;
}

- (NSMutableString *)$insert:(NSString *)aString at:(NSUInteger)anIndex {
  [self insertString:aString atIndex:anIndex];
  return self;
}

- (NSMutableString *)$set:(NSString *)aString {
  [self setString:aString];
  return self;
}

@end