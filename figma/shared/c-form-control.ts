// 그룹 c: Form Control 공통 (2026-11-16)
// main 파일의 Form Control 입력 자리는 SLOT이 아니라 고정 인스턴스 `Input`(= Form Control/Resource/Input)이다.
// Resource의 Type(TextField/TextArea/Select/Slot)을 보고, 안쪽 `Input` 인스턴스에서 입력 스니펫을 만든다.
// 근거: docs/plans/form-control-fixed-input-code-connect-draft-2026-11-09.md, main 실측(2026-11-16)
import { child, prop, type Inst } from './c-input';

export type InputKind = 'TextField' | 'TextArea' | 'Select' | 'Slot';

export const formControlInput = (fc: Inst | undefined): { kind: InputKind; inner?: Inst } => {
  const res = child(fc, 'Input');
  const type = prop(res, 'Type');
  if (type === 'TextField' || type === 'TextArea' || type === 'Select') {
    return { kind: type, inner: child(res, 'Input') };
  }
  if (type === 'Slot') return { kind: 'Slot' };
  // 안전장치: Type이 안 읽히고 입력 컴포넌트가 바로 잡힌 경우 고유 속성으로 판별
  if (prop(res, 'Render') !== undefined) return { kind: 'Select', inner: res };
  if (prop(res, 'Resize') !== undefined) return { kind: 'TextArea', inner: res };
  if (prop(res, 'Trailing Button') !== undefined) return { kind: 'TextField', inner: res };
  return { kind: 'Slot' };
};

/** Footer(Helper Text / Invalid Message / Success Message)의 메시지 텍스트. Message=False면 undefined */
export const footerMessage = (fc: Inst | undefined) => {
  if (prop(fc, 'Footer') !== true) return undefined;
  const footer = child(fc, 'Footer');
  if (!footer) return undefined;
  const msgOn = prop(footer, 'Message') === 'True';
  const readText = (name: string): string => {
    try {
      const v = (footer as { getString(n: string): unknown }).getString(name);
      return typeof v === 'string' ? v : '';
    } catch {
      return '';
    }
  };
  const text = msgOn
    ? readText('┗ Text​') || readText('┗ Invalid Text') || readText('┗ Success Text')
    : '';
  return { text: msgOn ? text : undefined, accessory: prop(footer, 'Accessory') === 'True' };
};
