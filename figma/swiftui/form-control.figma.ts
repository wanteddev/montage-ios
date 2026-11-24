// url=<FIGMA_FORM_CONTROL>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/3%20Selection%20And%20Input/FormControl.swift
// component=FormControl

// [2026-11-16] 근거: FormControl.swift L122(init input:), L150 .size, L158 .status, L166 .labelPlacement, L176 .label(_:required:),
// L189 .message, L200 .accessory. size·status는 슬롯 안 Montage 입력에 자동 전파(L114-121)되므로 입력 쪽에는 쓰지 않는다.
// 입력은 고정 인스턴스 'Input'(Form Control/Resource/Input)의 Type으로 고른다(shared/c-form-control.ts).
import figma from 'figma';

import { indent, iosSelect, iosTextArea, iosTextField, on, prop, str, sw } from '../shared/c-input';
import { footerMessage, formControlInput } from '../shared/c-form-control';

const I = figma.selectedInstance;
const { kind, inner } = formControlInput(I);
const input =
  kind === 'TextField' ? iosTextField(inner, { inherit: true })
  : kind === 'TextArea' ? iosTextArea(inner, { inherit: true })
  : kind === 'Select' ? iosSelect(inner, { inherit: true })
  : '// 입력 컴포넌트';

let code = `Montage.FormControl {\n    ${indent(input, '    ')}\n}`;
if (prop(I, 'Size') === 'Medium') code += '\n.size(.medium)';
const status = prop(I, 'Status');
if (status === 'Positive') code += '\n.status(.positive)';
if (status === 'Negative') code += '\n.status(.negative)';
if (prop(I, 'Label Placement') === 'Leading') code += '\n.labelPlacement(.leading)';
if (on(I, 'Label')) {
  const required = on(I, '┗ Required') ? ', required: true' : '';
  code += `\n.label("${sw(str(I, '┗ Text'))}"${required})`;
}
const footer = footerMessage(I);
if (footer?.text) code += `\n.message("${sw(footer.text)}")`;
if (footer?.accessory) code += '\n.accessory {\n    // 글자 수 카운트 등\n}';

export default { id: 'FormControl', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
