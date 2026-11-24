// url=<FIGMA_TOP_NAVIGATION_LEADING_IOS>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/6%20Navigations/TopNavigation.swift
// component=TopNavigation.LeadingButton

// [2026-11-16] 근거: TopNavigation.swift L595-603(LeadingButton(_ action: Resource.Leading?)), L744-761(Resource.Leading back·icon·text).
// Top Navigation/Resource/Leading/Normal/iOS (Type = Back·Icon Button·Text Button).
import figma from 'figma';

import { iosIcon } from '../shared/icon-name';
import { iosLeadingCase, readLeading } from '../shared/e-nav';

const l = readLeading(figma.selectedInstance, (n) => ({ ref: iosIcon(n) }));
const code = `Montage.TopNavigation.LeadingButton(${l ? iosLeadingCase(l) : 'nil'})`;

export default { id: 'TopNavigation.LeadingButton', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
