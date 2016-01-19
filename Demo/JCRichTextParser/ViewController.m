//
//  ViewController.m
//  JCRichTextParser
//
//  Copyright © 2016 Jimmy. All rights reserved.
//

#import "ViewController.h"
#import "JCRichTextParser.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *testCases;
@property (nonatomic, strong) JCRichTextParser *defaultParser;
@property (nonatomic, strong) JCRichTextParser *customizedParser;

@end

@implementation ViewController

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //init test cases
    self.testCases = @[
                       @"A <b>bold</b> and <i>italic</i> text",
                       @"A only <b><i>bold</i></b> text, nested tags are not supported",
                       @"A <italic_green>italic green</italic_green> and <large_bold>large bold</large_bold> <u>underline</u> text",
                       ];
    
    self.defaultParser = [JCRichTextParser defaultConvertorWithFontSize:17.0];
    
    JCRichTextTag *tag1 = [[JCRichTextTag alloc] initWithStartTag:@"<italic_green>" endTag:@"</italic_green>" attributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:17.0], NSForegroundColorAttributeName: [UIColor greenColor]}];
    JCRichTextTag *tag2 = [[JCRichTextTag alloc] initWithStartTag:@"<large_bold>" endTag:@"</large_bold>" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:34.0]}];
    JCRichTextTag *tag3 = [[JCRichTextTag alloc] initWithStartTag:@"<u>" endTag:@"</u>" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    self.customizedParser = [[JCRichTextParser alloc] initWithTags:@[tag1, tag2, tag3]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.testCases.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
        cell.textLabel.numberOfLines = 0;
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = self.testCases[indexPath.section];
    }
    else if (indexPath.row == 1)
    {
        if (indexPath.section == self.testCases.count -1)
        {
            cell.textLabel.attributedText = [self.customizedParser parseWithText:self.testCases[indexPath.section]];
        }
        else
        {
            cell.textLabel.attributedText = [self.defaultParser parseWithText:self.testCases[indexPath.section]];
        }
    }
    return cell;
}

@end
