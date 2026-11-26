// 그룹 c(텍스트 입력) 공통 헬퍼 (2026-11-16)
// TextField·TextArea·Select 스니펫을 InstanceHandle 하나에서 만든다.
// 단독 템플릿과 Form Control 템플릿(고정 `Input` 안쪽 입력)이 같은 함수를 쓴다.
import figma from 'figma';

import { androidIcon, iosIcon } from './icon-name';
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
/** Kotlin 문자열 리터럴 안에 넣을 값 */
export const kt = (s: string): string =>
  s.replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\$/g, '\\$');

/** 여러 줄 텍스트의 2번째 줄부터 들여쓰기를 더한다. */
export const indent = (code: string, pad: string): string => code.split('\n').join(`\n${pad}`);

export const iosIconOf = (inst: Inst | undefined): string =>
  iconFromInstance(inst, (n) => ({ ref: iosIcon(n) }))?.ref ?? '.blank';

/** Android 아이콘 참조. 리소스가 없는 아이콘이면 notes에 WRP-4628 주석을 모은다. */
export const androidIconOf = (inst: Inst | undefined, notes: string[]): string => {
  const found = iconFromInstance(inst, androidIcon) ?? { ref: 'R.drawable.icon_normal_blank' };
  if (found.note && !notes.includes(found.note)) notes.push(found.note);
  return found.ref;
};

export const P = 'com.wanted.android.wanted.design';

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

/** Compose 람다 한 덩어리. 인자 자리(4칸)에 들어간다고 보고 본문은 8칸, 닫는 괄호는 4칸. */
export const lambda = (body: string): string => `{\n        ${indent(body, '        ')}\n    }`;

const composeIcon = (ref: string): string =>
  `Icon(\n    modifier = Modifier.fillMaxSize(),\n    painter = painterResource(${ref}),\n    contentDescription = null\n)`;
const ICON_IMPORTS = [
  'import androidx.compose.foundation.layout.fillMaxSize',
  'import androidx.compose.material3.Icon',
  'import androidx.compose.ui.Modifier',
  'import androidx.compose.ui.res.painterResource',
];

type Out = { imports: Set<string>; notes: string[] };
const add = (o: Out, ...paths: string[]) => paths.forEach((p) => o.imports.add(p.startsWith('import ') ? p : `import ${p}`));

const composeIconButton = (ib: Inst | undefined, o: Out): string => {
  const T = `${P}.actions.button.iconbutton`;
  add(o, `${T}.WantedIconButtonNormal`);
  const args = [`icon = ${androidIconOf(child(ib, 'Icon'), o.notes)}`];
  const size = prop(ib, 'Size');
  if (typeof size === 'string' && ['Large', 'Medium', 'Small'].includes(size)) {
    args.push(`size = WantedIconButtonNormalSize.${size}`);
    add(o, `${T}.WantedIconButtonNormalSize`);
  }
  return `WantedIconButtonNormal(\n    ${args.join(',\n    ')}\n)`;
};

const composeBadge = (badge: Inst | undefined, o: Out): string => {
  const C = `${P}.contents.contentbadge`;
  add(o, `${C}.WantedContentBadge`);
  const args = [`text = "${kt(str(badge, 'Text'))}"`];
  if (prop(badge, 'Variant') === 'Outlined') {
    args.push('type = ContentBadgeType.Outlined');
    add(o, `${C}.ContentBadgeType`);
  }
  const size = prop(badge, 'Size');
  if (size === 'XSmall' || size === 'Medium') {
    args.push(`size = ContentBadgeSize.${size}`);
    add(o, `${C}.ContentBadgeSize`);
  }
  if (prop(badge, 'Color') === 'Accent') {
    args.push('color = ContentBadgeColor.Accent');
    add(o, `${C}.ContentBadgeColor`);
  }
  return `WantedContentBadge(\n    ${args.join(',\n    ')}\n)`;
};

const composeText = (text: string, o: Out): string => {
  add(o, 'androidx.compose.material3.Text');
  return `Text(text = "${kt(text)}")`;
};

// ───────────────────────── TextField ─────────────────────────
// iOS: TextField.swift init, size, status, placeholder, icon, trailingButton(TrailingButtonInfo), trailingContent
// Android: WantedTextField.kt 본체 오버로드(비-deprecated), WantedTextFieldDefaults.kt

export type InputOpts = {
  /** Form Control 안: iOS는 size·status가 FormControl에서 전파되므로 생략한다. */
  inherit?: boolean;
  /** Form Control 안(Android): FormControl 값으로 덮어쓴다(Android는 전파하지 않음). */
  size?: string;
  status?: string;
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

export type ComposeResult = { code: string; imports: string[] };

export const composeTextField = (inst: Inst | undefined, opts: InputOpts = {}): ComposeResult => {
  const o: Out = { imports: new Set(), notes: [] };
  const TF = `${P}.input.textinput.textfield`;
  add(o, `${TF}.WantedTextField`, 'androidx.compose.ui.text.input.TextFieldValue',
    'androidx.compose.foundation.interaction.MutableInteractionSource', 'androidx.compose.runtime.remember',
    'androidx.compose.foundation.text.KeyboardOptions', 'androidx.compose.foundation.text.KeyboardActions');
  const status = opts.status ?? (prop(inst, 'Status') as string | undefined);
  const size = opts.size ?? (prop(inst, 'Size') as string | undefined);
  const btn = on(inst, 'Trailing Button') ? child(inst, 'Trailing Button') : undefined;
  const value = on(inst, 'Active') ? kt(str(inst, 'Text')) : '';
  // 본체 오버로드는 아래 13개가 필수 인자다(기본값 없음). docstring 예시와 같은 순서.
  const args = [
    `value = TextFieldValue("${value}")`,
    `placeholder = "${kt(str(inst, 'Placeholder'))}"`,
    `error = ${status === 'Negative'}`,
    `enabled = ${!on(inst, 'Disable')}`,
    `trailingButtonEnabled = ${!on(btn, 'Disable')}`,
    `complete = ${status === 'Positive'}`,
    'maxLines = 1',
    'minLines = 1',
    'maxWordCount = 2000',
    'enabledOverflowText = false',
    'interactionSource = remember { MutableInteractionSource() }',
    'keyboardOptions = KeyboardOptions.Default',
    'keyboardActions = KeyboardActions.Default',
  ];
  if (size === 'Medium') {
    args.push('size = WantedTextFieldDefaults.Size.Medium');
    add(o, `${TF}.WantedTextFieldDefaults`);
  }
  if (btn) args.push(`trailingButton = "${kt(str(btn, 'Label'))}"`);
  if (on(inst, 'Trailing Content')) {
    const { tc, variant } = tfTrailingKind(inst);
    let body = '// 콘텐츠';
    if (variant === 'Timer') body = composeText(str(tc, 'Time'), o);
    else if (variant === 'Text') body = composeText(str(tc, 'Text'), o);
    else if (variant === 'Badge') body = composeBadge(child(tc, 'Content Badge/Content Badge'), o);
    else if (variant === 'Icon') {
      body = composeIcon(androidIconOf(child(tc, 'Icon'), o.notes));
      add(o, ...ICON_IMPORTS);
    } else if (variant === 'Icon Button') body = composeIconButton(child(tc, 'Icon Button'), o);
    args.push(`trailingContent = ${lambda(body)}`);
  }
  if (on(inst, 'Leading Icon')) {
    args.push(`leadingIcon = ${lambda(composeIcon(androidIconOf(child(inst, 'Icon'), o.notes)))}`);
    add(o, ...ICON_IMPORTS);
  }
  const head = on(inst, 'Auto Complete')
    ? ['// 자동완성 목록은 WantedAutoComplete(ExposedDropdownMenuBox 안)로 붙입니다.']
    : [];
  const code = [...o.notes, ...head, `WantedTextField(\n    ${args.join(',\n    ')}\n)`].join('\n');
  return { code, imports: [...o.imports] };
};

// ───────────────────────── TextArea ─────────────────────────
// iOS: TextArea.swift Resize, Resource, init, size, resize, negative, bottomResources, placeholder
// Android: WantedTextArea.kt 비-deprecated 오버로드(onValueChange 필수), WantedTextAreaDefaults.kt

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

const composeTaResource = (r: { res: Inst | undefined; type?: string }, o: Out): string => {
  const { res, type } = r;
  switch (type) {
    case 'Icon':
      add(o, ...ICON_IMPORTS);
      return composeIcon(androidIconOf(child(res, 'Icon'), o.notes));
    case 'Icon Button':
      return composeIconButton(child(res, 'Icon Button') ?? child(res, 'Button/Icon/Normal'), o);
    case 'Content Badge':
      return composeBadge(child(res, 'Content Badge/Content Badge'), o);
    case 'Primary Icon Button': {
      add(o, `${P}.actions.button.WantedButton`, `${P}.util.ButtonSize`);
      const icon = androidIconOf(child(child(res, 'Button/Button'), 'Icon'), o.notes);
      return `WantedButton(\n    text = "",\n    size = ButtonSize.SMALL,\n    leadingDrawable = ${icon}\n)`;
    }
    case 'Segmented Control':
      return '// WantedSegmentedControl (아이콘 전용, Small)';
    default:
      return '// 콘텐츠';
  }
};

export const composeTextArea = (inst: Inst | undefined, opts: InputOpts = {}): ComposeResult => {
  const o: Out = { imports: new Set(), notes: [] };
  const TA = `${P}.input.textinput.textarea`;
  add(o, `${TA}.WantedTextArea`, 'androidx.compose.ui.text.input.TextFieldValue');
  const status = opts.status ?? (prop(inst, 'Status') as string | undefined);
  const size = opts.size ?? (prop(inst, 'Size') as string | undefined);
  const value = on(inst, 'Active') ? kt(str(inst, 'Text')) : '';
  const args = [`value = TextFieldValue("${value}")`, `placeholder = "${kt(str(inst, 'Placeholder'))}"`];
  const head: string[] = [];
  if (status === 'Negative') {
    args.push('status = WantedTextAreaDefaults.Status.Negative');
    add(o, `${TA}.WantedTextAreaDefaults`);
  } else if (status === 'Positive') {
    head.push('// TextArea에는 Positive 상태가 없어 Normal로 표시됩니다.');
  }
  if (on(inst, 'Disable')) args.push('enabled = false');
  if (size === 'Medium') {
    args.push('size = WantedTextAreaDefaults.Size.Medium');
    add(o, `${TA}.WantedTextAreaDefaults`);
  }
  const resize = prop(inst, 'Resize');
  if (resize === 'Limit' || resize === 'Fixed') {
    args.push(`resize = WantedTextAreaDefaults.Resize.${resize}`);
    add(o, `${TA}.WantedTextAreaDefaults`);
  }
  const lead = taResource(inst, 'Leading');
  const trail = taResource(inst, 'Trailing');
  if (trail && trail.type === 'Button') {
    const b = child(trail.res, 'Button/Button');
    if (prop(b, 'Color') && prop(b, 'Color') !== 'Assistive')
      head.push('// Android button 인자는 색상을 받지 않아 기본 버튼으로 표시됩니다.');
    args.push(`button = "${kt(str(b, 'Label'))}"`);
  }
  if (lead) args.push(`leadingContent = ${lambda(composeTaResource(lead, o))}`);
  if (trail && trail.type !== 'Button') args.push(`trailingContent = ${lambda(composeTaResource(trail, o))}`);
  args.push('onValueChange = { }');
  const code = [...o.notes, ...head, `WantedTextArea(\n    ${args.join(',\n    ')}\n)`].join('\n');
  return { code, imports: [...o.imports] };
};

// ───────────────────────── Select ─────────────────────────
// iOS: Select.swift Variant, init, size, status, placeholder, leading, Resource.Leading
// Android: WantedSelect.kt 단일·String, 다중·String, WantedSelectDefaults.kt

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

export const composeSelect = (inst: Inst | undefined, opts: InputOpts = {}): ComposeResult => {
  const o: Out = { imports: new Set(), notes: [] };
  const S = `${P}.input.select`;
  add(o, `${S}.WantedSelect`);
  const chip = prop(inst, 'Render') === 'Chip';
  const active = on(inst, 'Active');
  const status = opts.status ?? (prop(inst, 'Status') as string | undefined);
  const size = opts.size ?? (prop(inst, 'Size') as string | undefined);
  const head: string[] = [];
  const args = chip
    ? [`valueList = ${active ? 'listOf("옵션 1")' : 'emptyList()'}`]
    : [`value = "${active ? kt(str(inst, 'Value')) : ''}"`];
  args.push(`placeHolder = "${kt(str(inst, 'Placeholder'))}"`);
  args.push(`enabled = ${!on(inst, 'Disable')}`);
  args.push('selectValueList = listOf("옵션 1", "옵션 2")');
  if (status === 'Negative') {
    args.push('status = WantedSelectDefaults.Status.Negative');
    add(o, `${S}.WantedSelectDefaults`);
  } else if (status === 'Positive') {
    head.push('// Select에는 Positive 상태가 없어 Normal로 표시됩니다.');
  }
  if (chip) {
    if (on(inst, 'Overflow')) args.push('overflow = true');
    args.push('render = WantedSelectDefaults.MultiSelectRender.Chip');
    add(o, `${S}.WantedSelectDefaults`);
  }
  if (size === 'Medium') {
    args.push('size = WantedSelectDefaults.Size.Medium');
    add(o, `${S}.WantedSelectDefaults`);
  }
  const lead = selectLeading(inst);
  if (lead?.kind === 'icon') {
    add(o, ...ICON_IMPORTS);
    args.push(`leadingIcon = ${lambda(composeIcon(androidIconOf(lead.inst, o.notes)))}`);
  }
  if (lead?.kind === 'iconButton') args.push(`leadingIcon = ${lambda(composeIconButton(lead.inst, o))}`);
  if (lead?.kind === 'slot') args.push(`leadingIcon = ${lambda('// 콘텐츠')}`);
  const code = [...o.notes, ...head, `WantedSelect(\n    ${args.join(',\n    ')}\n)`].join('\n');
  return { code, imports: [...o.imports] };
};
