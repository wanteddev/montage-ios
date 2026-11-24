// url=<FIGMA_SECTION_HEADER>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/SectionHeader.swift
// component=SectionHeader

// [2026-11-16] 근거: SectionHeader.swift L65(init title:), L91(size 기본 .medium), L109(size), L136(headingContent), L149(trailingContent).
// Platform(Mobile/Desktop)은 iOS API가 없어 반영하지 않는다.
import figma from 'figma';

import { headerSlot } from '../shared/d-section-header';
import { block, flag, I, text } from '../shared/d-util';

const lines = [`Montage.SectionHeader(title: "${text('Heading', '제목')}")`];
const size = ({ XSmall: '.xsmall', Small: '.small', Large: '.large' } as Record<string, string>)[String(I.getPropertyValue('Size'))];
if (size) lines.push(`.size(${size})`);
if (flag('Show Heading Content')) lines.push(`.headingContent ${block(headerSlot('Heading Content'))}`);
if (flag('Show Trailing Content')) lines.push(`.trailingContent ${block(headerSlot('Trailing Content', 'ios'))}`);

export default {
  id: 'SectionHeader',
  imports: ['import Montage'],
  example: figma.code`${lines.join('\n')}`,
  metadata: { nestable: true },
};
