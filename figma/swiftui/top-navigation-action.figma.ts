// url=<FIGMA_TOP_NAVIGATION_ACTION>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/TopNavigation.swift
// component=TopNavigation.TrailingIconButton

// [2026-11-16] 근거: TopNavigation.swift TrailingTextButton(text:action:), TrailingIconButton(icon:showPushBadge:action:).
// Top Navigation/Resource/Action/Normal (Variant = Icon·Text). Icon의 Badge → showPushBadge.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { IOS_ACTION, q, readAction } from '../shared/e-nav';

const t = readAction(figma.selectedInstance, (n) => ({ ref: iosIcon(n) }));
let code: string;
if (t?.kind === 'text') {
  code = `Montage.TopNavigation.TrailingTextButton(text: ${q(t.text)})${IOS_ACTION}`;
} else {
  const args = [`icon: ${t?.icon?.ref ?? '.blank'}`];
  if (t?.badge) args.push('showPushBadge: true');
  code = `Montage.TopNavigation.TrailingIconButton(${args.join(', ')})${IOS_ACTION}`;
}

export default { id: 'TopNavigation.TrailingButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
