//
//  JCRichTextParser.h
//  JCRichTextParser
//
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCRichTextParser : NSObject

+ (instancetype)defaultParserWithFontSize:(CGFloat)fontSize;
- (instancetype)initWithTags:(NSArray *)tags;

/*
 Using tags to parser rich text.
 Nested tags are not supported.
 See demo for details.
 */
- (NSAttributedString *)parseWithText:(NSString *)text;

@end

@interface JCRichTextTag: NSObject <NSCopying>

@property (nonatomic, copy) NSString *startTag;
@property (nonatomic, copy) NSString *endTag;
@property (nonatomic, copy) NSDictionary *attributes;

@property (nonatomic, assign) NSRange range; // used to store the tag range in text, optional

- (instancetype)initWithStartTag:(NSString *)startTag endTag:(NSString *)endTag attributes:(NSDictionary *)attributes;

@end

@interface JCRichTextHelper: NSObject

+ (NSArray *)defaultRichTextTagsWithFontSize:(CGFloat)fontSize; // bold and italic

@end
