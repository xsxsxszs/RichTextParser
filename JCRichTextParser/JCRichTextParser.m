//
//  JCRichTextParser.m
//  JCRichTextParser
//
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "JCRichTextParser.h"

@interface JCRichTextParser ()

@property (nonatomic, strong) NSArray *tags;

@end

@implementation JCRichTextParser

+ (instancetype)defaultParserWithFontSize:(CGFloat)fontSize
{
    static JCRichTextParser *_defaultParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultParser = [[self alloc] initWithTags:[JCRichTextHelper defaultRichTextTagsWithFontSize:fontSize]];
    });
    
    return _defaultParser;
}

- (instancetype)initWithTags:(NSArray *)tags
{
    self = [super init];
    if (self)
    {
        self.tags = tags;
    }
    return self;
}

- (NSAttributedString *)parseWithText:(NSString *)text
{
    if (text.length == 0)
    {
        return nil;
    }
    
    // find all tags in text
    NSMutableArray *validTags = [NSMutableArray new];
    NSUInteger startLoc = 0;
    while (startLoc < text.length)
    {
        NSUInteger validStartLoc = text.length;
        NSUInteger validEndLoc = text.length;
        JCRichTextTag *validTag = nil;
        for (JCRichTextTag *tag in self.tags)
        {
            NSRange startTagSearchRange = NSMakeRange(startLoc, text.length - startLoc);
            NSRange startTagResultRange = [text rangeOfString:tag.startTag options:NSLiteralSearch range:startTagSearchRange locale:[NSLocale currentLocale]];
            if (startTagResultRange.length > 0)
            {
                NSRange endTagSearchRange = NSMakeRange(startTagResultRange.location + startTagResultRange.length, text.length - (startTagResultRange.location + startTagResultRange.length));
                NSRange endTagResultRange = [text rangeOfString:tag.endTag options:NSLiteralSearch range:endTagSearchRange locale:[NSLocale currentLocale]];
                if (endTagResultRange.length > 0 && startTagResultRange.location < validStartLoc)
                {
                    validStartLoc = startTagResultRange.location;
                    validEndLoc = endTagResultRange.location + endTagResultRange.length;
                    validTag  = tag;
                    validTag.range = NSMakeRange(validStartLoc, validEndLoc - validStartLoc);
                }
            }
        }
        if (validTag)
        {
            [validTags addObject:[validTag copy]];
        }
        startLoc = validEndLoc;
    }
    
    // replace tag with attributed string
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:text];
    NSEnumerator *enumerator = [validTags reverseObjectEnumerator];
    for (JCRichTextTag *tag in enumerator)
    {
        NSRange stringWithoutTagRange = NSMakeRange(tag.range.location + tag.startTag.length, tag.range.length - tag.startTag.length - tag.endTag.length);
        NSString *stringWithoutTag = [text substringWithRange:stringWithoutTagRange];
        [richText replaceCharactersInRange:tag.range withAttributedString:[[NSAttributedString alloc]initWithString:stringWithoutTag attributes:tag.attributes]];
    }
    return richText;
}

@end

// BBRichTextTag

@implementation JCRichTextTag

- (instancetype)initWithStartTag:(NSString *)startTag endTag:(NSString *)endTag attributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self)
    {
        self.startTag = startTag;
        self.endTag = endTag;
        self.attributes = attributes;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    JCRichTextTag *tag = [[self.class alloc] initWithStartTag:self.startTag endTag:self.endTag attributes:self.attributes];
    tag.range = self.range;
    return tag;
}

@end


// BBRichTextHelper

@implementation JCRichTextHelper

+ (JCRichTextTag *)italicRichTextTagWithFontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont italicSystemFontOfSize:fontSize]};
    JCRichTextTag *tag = [[JCRichTextTag alloc] initWithStartTag:@"<i>" endTag:@"</i>" attributes:attributes];
    return tag;
}

+ (JCRichTextTag *)boldRichTextTagWithFontSize:(CGFloat)fontSize
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]};
    JCRichTextTag *tag = [[JCRichTextTag alloc] initWithStartTag:@"<b>" endTag:@"</b>" attributes:attributes];
    return tag;
}

+ (NSArray *)defaultRichTextTagsWithFontSize:(CGFloat)fontSize
{
    JCRichTextTag *italicTag = [self italicRichTextTagWithFontSize:fontSize];
    JCRichTextTag *boldTag = [self boldRichTextTagWithFontSize:fontSize];
    return @[italicTag, boldTag];
}

@end