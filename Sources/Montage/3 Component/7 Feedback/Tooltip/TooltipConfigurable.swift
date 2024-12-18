//
//  TooltipConfigurable.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/3/24.
//

import SwiftUI

public protocol TooltipConfigurable {
    var variant: Tooltip.Variant { get set }

    var position: Tooltip.Position { get set }
    var margin: CGFloat { get set }

    var inverse: Bool { get set }
    var width: CGFloat? { get set }
    var height: CGFloat? { get set }
    var borderRadius: CGFloat { get set }

    var showArrow: Bool { get set }
    var arrowWidth: CGFloat { get set }
    var arrowHeight: CGFloat { get set }

    var showCloseButton: Bool { get set }
}
