//
//  HKNotesListCell.h
//  Code
//
//  Created by Ivan li on 2021/1/4.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKNotesModel;

@protocol HKNotesListCellDelegate <NSObject>
//- (void)notesListCellDidOpenBtn;
- (void)notesListCellDidTimeBtn:(HKNotesModel *)noteModel;
- (void)notesListCellDidImgV:(HKNotesModel *)noteModel;
- (void)notesListCellDidZanBtn:(HKNotesModel *)noteModel;
- (void)notesListCellDidMoreBtn:(HKNotesModel *)noteModel;
@end

@interface HKNotesListCell : UITableViewCell
@property (nonatomic,strong) HKNotesModel *noteModel;
@property (nonatomic , strong) void(^didOpenBlock)(void);
@property (nonatomic,weak) id<HKNotesListCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
