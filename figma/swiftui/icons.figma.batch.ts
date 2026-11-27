// [2026-11-16] 아이콘 노드 → iOS `Icon` case.
// 노드 목록(icons.figma.batch.json)은 scripts/icon_sync.js가 아이콘 동기화 때 다시 만든다. 손으로 고치지 않는다.
import figma from 'figma';

import { iosIcon, nameFromComponent } from '../shared/icon-name';

const { variants } = figma.batch as {
  variants: Array<{ name: string; component: string }>;
};
// Figma Name variant에 공백이 섞인 경우가 있다(예: `leftSide `).
const name = String(figma.selectedInstance.getPropertyValue('Name')).trim();
const { component } =
  variants.find((v) => v.name.trim() === name) ?? variants[0];
const icon = iosIcon(nameFromComponent(component));

export default {
  id: component,
  imports: ['import Montage'],
  example: figma.code`Image.icon(${icon})`,
  // 버튼 등 상위 템플릿이 아이콘 표기를 가져다 쓰도록 노출
  metadata: { nestable: true, props: { icon } },
};
