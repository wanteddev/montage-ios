// url=<FIGMA_PLAY_BADGE>
// source=https://github.com/wanteddev/montage-ios/blob/main/Sources/Montage/1%20Components/4%20Contents/PlayBadge.swift
// component=PlayBadge

// [2026-11-16] 근거: PlayBadge.swift init, .size(기본 .medium), .alternative.
import figma from 'figma';

import { flag } from '../shared/a-util';

const I = figma.selectedInstance;
const size = I.getEnum('Size', { Small: '.small', Medium: '.medium', Large: '.large' });
let code = 'Montage.PlayBadge()';
if (size !== '.medium') code += `\n.size(${size})`;
if (flag('Alternative')) code += '\n.alternative()';

export default { id: 'PlayBadge', imports: ['import Montage'], example: figma.code`${code}`, metadata: { nestable: true } };
