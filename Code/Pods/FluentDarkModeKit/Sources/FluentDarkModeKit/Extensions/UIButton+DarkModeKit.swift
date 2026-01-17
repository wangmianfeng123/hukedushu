//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIButton {
  override func dm_updateDynamicColors() {
    super.dm_updateDynamicColors()

    if #available(iOS 9.0, *) {
        [UIControl.State.normal, .highlighted, .disabled, .selected, .focused].forEach { state in
            if let color = titleColor(for: state)?.copy() as? DynamicColor {
                setTitleColor(color, for: state)
            }
        }
    } else {
        // Fallback on earlier versions
    }
  }
}
