//
//  NewCommentCell.h
//  Code
//
//  Created by Ivan li on 2017/10/30.
//  Copyright © 2017年 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCommentModel,CommentChildModel;

@interface NewCommentCell : UITableViewCell

//+ (instancetype)initCellWithTableView:(UITableView *)tableView;
+ (instancetype)initCellWithTableView:(UITableView *)tableView  row:(NSInteger)row;

//@property(strong,nonatomic)NewCommentModel  *commentModel;
@property(strong,nonatomic)CommentChildModel  *model;

@end
