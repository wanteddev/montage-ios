// 그룹 c(텍스트 입력) 공통 헬퍼 (2026-11-16)
// TextField·TextArea·Select 스니펫을 InstanceHandle 하나에서 만든다.
// 단독 템플릿과 Form Control 템플릿(고정 `Input` 안쪽 입력)이 같은 함수를 쓴다.
import figma from 'figma';

import { iosIcon } from './icon-name';
import { iconFromInstance } from './resolve-icon';

export type Inst = ReturnType<typeof figma.selectedInstance.findInstance>;

const safe = <T>(fn: () => T): T | undefined => {
  try {
    return fn();
  } catch {
    return undefined;
  }
};

/** 속성값. 없거나 오류면 undefined */
export const prop = (inst: Inst | undefined, name: string): unknown => {
  if (!inst || inst.type === 'ERROR') return undefined;
  const v = safe(() => inst.getPropertyValue(name)) as unknown;
  if (v && typeof v === 'object' && (v as { type?: string }).type === 'ERROR') return undefined;
  return v;
};

/** BOOLEAN 속성과 True/False VARIANT 속성을 모두 참/거짓으로 읽는다. */
export const on = (inst: Inst | undefined, name: string): boolean => {
  const v = prop(inst, name);
  return v === true || v === 'True' || v === 'true';
};

/** TEXT 속성. 없으면 '' */
export const str = (inst: Inst | undefined, name: string): string => {
  if (!inst || inst.type === 'ERROR') return '';
  const v = safe(() => inst.getString(name)) as unknown;
  return typeof v === 'string' ? v : '';
};

/** 이름으로 찾은 하위 인스턴스. 없으면 undefined */
export const child = (inst: Inst | undefined, name: string): Inst | undefined => {
  if (!inst || inst.type === 'ERROR') return undefined;
  const c = safe(() => inst.findInstance(name));
  return c && c.type !== 'ERROR' ? c : undefined;
};

/** Swift 문자열 리터럴 안에 넣을 값 */
export const sw = (s: string): string => s.replace(/\\/g, '\\\\').replace(/"/g, '\\"');

/** 여러 줄 텍스트의 2번째 줄부터 들여쓰기를 더한다. */
export const indent = (code: string, pad: string): string => code.split('\n').join(`\n${pad}`);

const iosIconOf = (inst: Inst | undefined): string =>
  iconFromInstance(inst, (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank';

// ───────────────────────── 공용 하위 요소 ─────────────────────────

const iosIconButton = (ib: Inst | undefined): string => {
  const size = prop(ib, 'Size');
  const map: Record<string, string> = { Large: '.large', Medium: '.medium', Small: '.small' };
  const args: string[] = [];
  if (typeof size === 'string' && map[size]) args.push(`variant: .normal(size: ${map[size]})`);
  args.push(`icon: ${iosIconOf(child(ib, 'Icon'))}`);
  return `Montage.IconButton(${args.join(', ')}) {\n    // action\n}`;
};

const iosBadge = (badge: Inst | undefined): string => {
  const args: string[] = [];
  if (prop(badge, 'Variant') === 'Outlined') args.push('variant: .outlined');
  args.push(`text: "${sw(str(badge, 'Text'))}"`);
  let code = `Montage.ContentBadge(${args.join(', ')})`;
  const size = prop(badge, 'Size');
  if (size === 'XSmall') code += '\n.size(.xsmall)';
  if (size === 'Medium') code += '\n.size(.medium)';
  if (prop(badge, 'Color') === 'Accent') code += '\n.colorStyle(.accent(<#accent 색상#>))';
  return code;
};

// ───────────────────────── TextField ─────────────────────────
// iOS: TextField.swift init, size, status, placeholder, icon, trailingButton(TrailingButtonInfo), trailingContent

export type InputOpts = {
  /** Form Control 안: iOS는 size·status가 FormControl에서 전파되므로 생략한다. */
  inherit?: boolean;
};

const tfTrailingKind = (inst: Inst | undefined) => {
  const tc = child(inst, 'Trailing Content');
  return { tc, variant: prop(tc, 'Variant') as string | undefined };
};

export const iosTextField = (inst: Inst | undefined, opts: InputOpts = {}): string => {
  const args = ['text: $text'];
  if (on(inst, 'Auto Complete')) args.push('autoCompletionDataSource: $autoCompletion');
  let code = `Montage.TextField(${args.join(', ')})`;
  code += `\n.placeholder("${sw(str(inst, 'Placeholder'))}")`;
  if (!opts.inherit) {
    if (prop(inst, 'Size') === 'Medium') code += '\n.size(.medium)';
    const status = prop(inst, 'Status');
    if (status === 'Positive') code += '\n.status(.positive)';
    if (status === 'Negative') code += '\n.status(.negative)';
  }
  if (on(inst, 'Leading Icon')) code += `\n.icon(${iosIconOf(child(inst, 'Icon'))})`;
  if (on(inst, 'Trailing Content')) {
    const { tc, variant } = tfTrailingKind(inst);
    // TextField는 trailingContent에 스타일을 입히지 않는다(2026-11-16 김삼열 님 검수). Figma 실측으로 지정:
    // Timer·Text = Large Body 2/Regular, Medium Label 1/Regular, Foreground/Neutral/Primary. Icon = 20, Foreground/Neutral/Tertiary.
    const typo = `.typography(variant: ${prop(inst, 'Size') === 'Medium' ? '.label1' : '.body2'}, weight: .regular, semantic: .foregroundNeutralPrimary)`;
    let body = '// 콘텐츠';
    if (variant === 'Timer') body = `Text("${sw(str(tc, 'Time'))}")\n    ${typo}`;
    else if (variant === 'Text') body = `Text("${sw(str(tc, 'Text'))}")\n    ${typo}`;
    else if (variant === 'Badge') body = iosBadge(child(tc, 'Content Badge/Content Badge'));
    else if (variant === 'Icon')
      body = `Image.icon(${iosIconOf(child(tc, 'Icon'))})\n    .resizable()\n    .renderingMode(.template)\n    .frame(width: .dimension20, height: .dimension20)\n    .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralTertiary))`;
    else if (variant === 'Icon Button') body = iosIconButton(child(tc, 'Icon Button'));
    code += `\n.trailingContent {\n    ${indent(body, '    ')}\n}`;
  }
  if (on(inst, 'Trailing Button')) {
    const btn = child(inst, 'Trailing Button');
    const a = [`title: "${sw(str(btn, 'Label'))}"`];
    if (on(btn, 'Disable')) a.push('disable: true');
    code += `\n.trailingButton(.init(${a.join(', ')}) {\n    // action\n})`;
  }
  if (on(inst, 'Disable')) code += '\n.disabled(true)';
  return code;
};

// ───────────────────────── TextArea ─────────────────────────
// iOS: TextArea.swift Resize, Resource, init, size, resize, negative, bottomResources, placeholder

const taResource = (inst: Inst | undefined, side: 'Leading' | 'Trailing') => {
  if (!on(inst, 'Bottom') || !on(inst, `┗ ${side} Content`)) return undefined;
  const res = child(inst, `${side} Content`);
  return { res, type: prop(res, 'Type') as string | undefined };
};

const iosTaResource = (r: { res: Inst | undefined; type?: string }): string => {
  const { res, type } = r;
  switch (type) {
    case 'Icon':
      return `.icon(${iosIconOf(child(res, 'Icon'))})`;
    case 'Icon Button':
      return `.iconButton(icon: ${iosIconOf(child(child(res, 'Icon Button') ?? child(res, 'Button/Icon/Normal'), 'Icon'))})`;
    case 'Content Badge': {
      const badge = child(res, 'Content Badge/Content Badge');
      const v = prop(badge, 'Variant') === 'Outlined' ? '.outlined, ' : '';
      return `.contentBadge(${v}title: "${sw(str(badge, 'Text'))}")`;
    }
    case 'Segmented Control':
      return '.segmentedControl(selectedIndex: $selectedIndex, icons: [<#아이콘#>])';
    case 'Button': {
      const b = child(res, 'Button/Button');
      const color = prop(b, 'Color');
      const c = color === 'Primary' ? 'color: .primary, ' : color === 'Negative' ? 'color: .negative, ' : '';
      return `.button(${c}title: "${sw(str(b, 'Label'))}")`;
    }
    case 'Primary Icon Button':
      return `.primaryIconButton(icon: ${iosIconOf(child(child(res, 'Button/Button'), 'Icon'))})`;
    default:
      return '.slot {\n    // 콘텐츠\n}';
  }
};

export const iosTextArea = (inst: Inst | undefined, opts: InputOpts = {}): string => {
  let code = 'Montage.TextArea(text: $text)';
  code += `\n.placeholder("${sw(str(inst, 'Placeholder'))}")`;
  if (!opts.inherit && prop(inst, 'Size') === 'Medium') code += '\n.size(.medium)';
  const resize = prop(inst, 'Resize');
  if (resize === 'Limit') code += '\n.resize(.limit)';
  if (resize === 'Fixed') code += '\n.resize(.fixed(min: <#최소 높이#>, max: <#최대 높이#>))';
  if (!opts.inherit && prop(inst, 'Status') === 'Negative') code += '\n.negative()';
  const lead = taResource(inst, 'Leading');
  const trail = taResource(inst, 'Trailing');
  if (lead || trail) {
    const parts: string[] = [];
    if (lead) parts.push(`leading: [${indent(iosTaResource(lead), '    ')}]`);
    if (trail) parts.push(`trailing: [${indent(iosTaResource(trail), '    ')}]`);
    code += `\n.bottomResources(\n    ${parts.join(',\n    ')}\n)`;
  }
  if (on(inst, 'Disable')) code += '\n.disabled(true)';
  return code;
};

// ───────────────────────── Select ─────────────────────────
// iOS: Select.swift Variant, init, size, status, placeholder, leading, Resource.Leading

/** 슬롯 '┗ Leading Content' 안의 Select/Resource/Leading Content/* 를 종류별로 판별한다. */
const selectLeading = (inst: Inst | undefined) => {
  if (!on(inst, 'Leading Content')) return undefined;
  const res = child(inst, 'Leading Content');
  const ib = child(res, 'Icon Button');
  if (ib) return { kind: 'iconButton' as const, inst: ib };
  const icon = child(res, 'Icons/Icons');
  if (icon) return { kind: 'icon' as const, inst: icon };
  return { kind: 'slot' as const, inst: res };
};

export const iosSelect = (inst: Inst | undefined, opts: InputOpts = {}): string => {
  const chip = prop(inst, 'Render') === 'Chip';
  const overflow = on(inst, 'Overflow');
  const variant = chip
    ? `.multiple(render: .chip, ${overflow ? 'overflow: true, ' : ''}menuPrimaryButtonTitle: "<#확인 버튼 제목#>")`
    : '.single()';
  let code = `Montage.Select(variant: ${variant}, items: $items)`;
  code += `\n.placeholder("${sw(str(inst, 'Placeholder'))}")`;
  if (!opts.inherit && prop(inst, 'Size') === 'Medium') code += '\n.size(.medium)';
  if (!opts.inherit && prop(inst, 'Status') === 'Negative') code += '\n.status(.negative)';
  const lead = selectLeading(inst);
  if (lead?.kind === 'icon') code += `\n.leading(.icon(${iosIconOf(lead.inst)}))`;
  if (lead?.kind === 'iconButton') code += `\n.leading(.iconButton(${indent(iosIconButton(lead.inst), '')}))`;
  if (lead?.kind === 'slot') code += '\n.leading(.slot {\n    // 콘텐츠\n})';
  if (on(inst, 'Disable')) code += '\n.disabled(true)';
  return code;
};
