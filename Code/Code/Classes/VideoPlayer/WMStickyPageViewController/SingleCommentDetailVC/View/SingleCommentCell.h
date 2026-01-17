//
//  SingleCommentCell.h
//  Code
//
//  Created by Ivan li on 2017/10/31.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCommentModel , HKCommentModel ,CommentChildModel;

@interface SingleCommentCell : UITableViewCell

+ (instancetype)initCellWithTableView:(UITableView *)tableView;

@property(strong,nonatomic)NewCommentModel  *commentModel;

@property(strong,nonatomic)CommentChildModel  *model;

@property (nonatomic , strong) HKCommentModel * monmentCommentModel;
@end
