// url=<FIGMA_SNACKBAR>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/7%20Feedback/SnackBar.swift
// component=SnackBar

// [2026-11-16] 근거: SnackBar.swift Model(heading:description:extraContents:action:), View.snackBar(_:location:closeButtonEnabled:handler:).
// Leading Icon → extraContents, Close Button → closeButtonEnabled, 액션 라벨은 안쪽 'Button'(Text Button) Label.
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iconFromLayer } from '../shared/resolve-icon';
import { flag, textOf } from '../shared/a-util';

const I = figma.selectedInstance;
const safe = <T>(fn: () => T): T | undefined => { try { return fn(); } catch { return undefined; } };
const btn = safe(() => I.findInstance('Button'));
const action = String((btn && btn.type !== 'ERROR' ? safe(() => btn.getString('Label')) : undefined) ?? '확인').replace(/"/g, '\\"');

const args: string[] = [];
if (flag('Heading')) args.push(`heading: "${textOf('┗ Text')}"`);
if (flag('Description')) args.push(`description: "${textOf('┗ Text​')}"`);
if (flag('Leading Icon')) {
  const icon = iconFromLayer('Icon', (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank';
  args.push(`extraContents: {\n        Image.icon(${icon})\n    }`);
}
args.push(`action: "${action}"`);

const hostArgs = flag('Close Button') ? '$snackBarModel, closeButtonEnabled: true' : '$snackBarModel';
const code = `ContentView()\n    .snackBar(${hostArgs}) {\n        // action\n    }\n\n// 모델을 넣으면 표시됩니다.\nsnackBarModel = Montage.SnackBar.Model(\n    ${args.join(',\n    ')}\n)`;

export default { id: 'SnackBar', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
