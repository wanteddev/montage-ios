// url=<FIGMA_ICONS_WRAPPER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/9%20Utilities/Icon.swift
// component=Icon

// [2026-11-16] Icons 래퍼: 안에 교체된 아이콘을 iOS Icon case로 보여 주고, 상위 템플릿에 넘긴다.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromInstance } from '../shared/resolve-icon';

const found = iconFromInstance(
  figma.selectedInstance.getInstanceSwap('Icon'),
  (name) => ({ ref: iosIcon(name) }),
);
const icon = found?.ref ?? '.blank';

export default {
  id: 'IconsWrapper',
  imports: ['import Montage'],
  example: figma.code`Image.icon(${icon})`,
  metadata: { nestable: true, props: { icon } },
};
