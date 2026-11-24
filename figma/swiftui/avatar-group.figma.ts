// url=<FIGMA_AVATAR_GROUP>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/AvatarGroup.swift
// component=AvatarGroup

// [2026-11-16] 근거: AvatarGroup.swift L65(init(_ imageUrls:size:onTap:), size 필수), L168(.trailingContent).
// 그룹은 .person만 지원(L190-196). Trailing Content 교체 리소스: Text Button / Text / Custom.
// Text 프리셋은 docstring 예시(L31-32)의 타이포를 그대로 쓴다.
import figma from 'figma';

import { flag } from '../shared/a-util';

const I = figma.selectedInstance;
const size = I.getEnum('Size', { XSmall: '.xsmall', Small: '.small' });
let code = `Montage.AvatarGroup(imageUrls, size: ${size})`;

const safe = <T>(fn: () => T): T | undefined => { try { return fn(); } catch { return undefined; } };
if (flag('Trailing Content')) {
  const trailing = safe(() => I.findInstance('Trailing Content'));
  const ok = (n: unknown) => !!n && (n as { type?: string }).type !== 'ERROR';
  const tb = ok(trailing) ? safe(() => trailing!.findInstance('Text Button/Text Button')) : undefined;
  const tx = ok(trailing) ? safe(() => trailing!.findText('텍스트')) : undefined;
  let body = '// 콘텐츠';
  if (ok(tb)) {
    const label = String(safe(() => tb!.getString('Label')) ?? '').replace(/"/g, '\\"');
    body = `Montage.TextButton(color: .assistive, size: .small, text: "${label}") {\n        // action\n    }`;
  } else if (ok(tx)) {
    const t = String(safe(() => tx!.textContent) ?? '').replace(/"/g, '\\"');
    body = `Text("${t}")\n        .typography(variant: .label1, weight: .medium, semantic: .foregroundNeutralSecondary)`;
  }
  code += `\n.trailingContent {\n    ${body}\n}`;
}

export default { id: 'AvatarGroup', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
