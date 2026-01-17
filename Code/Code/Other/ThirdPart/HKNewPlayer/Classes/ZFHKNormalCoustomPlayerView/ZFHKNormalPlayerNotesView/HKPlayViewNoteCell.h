//
//  HKPlayViewNoteCell.h
//  Code
//
//  Created by Ivan li on 2021/1/6.
//  Copyright © 2021 pg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HKNotesModel;

@protocol HKPlayViewNoteCellDelegate <NSObject>
- (void)notesListCellDidTimeBtn:(HKNotesModel *)noteModel;
- (void)notesListCellDidZanBtn:(HKNotesModel *)noteModel;
@end

@interface HKPlayViewNoteCell : UITableViewCell
@property (nonatomic , strong) HKNotesModel * noteModel;
@property (nonatomic , strong) void(^didOpenBlock)(void);
@property (nonatomic,weak) id<HKPlayViewNoteCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
