// Figma 아이콘 이름 → 플랫폼별 아이콘 표기 변환 (2026-11-16)
// 근거: docs/plans/code-connect-icon-name-mapping-2026-11-16.md
// 입력은 Web 아이콘 컴포넌트명에서 'Icon'을 뗀 이름(예: IconAgentColor → agentColor)
// 또는 Figma 아이콘 인스턴스의 Name variant(예: heart).

/** iOS `Icon` enum case. 이름이 그대로 일치한다(scripts/tests/icon_code_connect_batch.test.js에서 확인). */
export const iosIcon = (name: string): string => `.${name}`;

const snake = (name: string): string =>
  name.replace(/([a-z0-9])([A-Z])/g, '$1_$2').toLowerCase();

/** 규칙(icon_normal_ + snake_case)과 다른 Android 리소스. 5.0 전까지 유지. */
const ANDROID_EXCEPTIONS: Record<string, string> = {
  navigationCareer: 'icon_navigation_career',
  navigationMenu: 'icon_navigation_menu',
  navigationMypage: 'icon_navigation_mypage',
  navigationRecruit: 'icon_navigation_recruit',
  navigationSocial: 'icon_navigation_social',
  agentColor: 'icon_color_agent',
  blankColor: 'icon_color_blank',
  logoAppleColor: 'icon_color_logo_logo_apple',
  logoFacebookColor: 'icon_color_logo_logo_facebook',
  logoGoogleColor: 'icon_color_logo_logo_google',
  logoGooglePlayColor: 'icon_color_logo_logo_google_play',
  logoKakaoColor: 'icon_color_logo_logo_kakao',
  logoLinkedInColor: 'icon_color_logo_logo_linkedin',
  logoMicrosoftColor: 'icon_color_logo_logo_microsoft',
  logoNaverBlogColor: 'icon_color_logo_logo_naver_blog',
  logoYoutubeColor: 'icon_color_logo_logo_youtube',
  // 이름 불일치 4종: 기존 티켓에서 5.0 때 정리 예정
  flipBackward: 'icon_normal_flip_backword',
  squareLatinFill: 'icon_normal_square_fill_latin',
  strikethrough: 'icon_normal_strike_through',
  printer: 'icon_normal_print',
};

/** Android에 아직 없는 리소스 (WRP-4628에서 추가 예정). 추가되면 이 목록에서 지운다. */
const ANDROID_MISSING: Record<string, string> = {
  arrowDownThick: 'icon_normal_arrow_down_thick',
  arrowLeftThick: 'icon_normal_arrow_left_thick',
  arrowRightThick: 'icon_normal_arrow_right_thick',
  arrowUpThick: 'icon_normal_arrow_up_thick',
  diamond: 'icon_normal_diamond',
  diamondFill: 'icon_normal_diamond_fill',
  handleDesktop: 'icon_normal_handle_desktop',
  logoInstagramColor: 'icon_color_logo_logo_instagram',
};

/** Android drawable 참조와, 리소스가 없을 때 붙일 주석. */
export const androidIcon = (
  name: string,
): { ref: string; note?: string } => {
  const missing = ANDROID_MISSING[name];
  if (missing) {
    return {
      ref: `R.drawable.${missing}`,
      note: `// Android 리소스 없음: ${missing} (WRP-4628에서 추가 예정)`,
    };
  }
  const res = ANDROID_EXCEPTIONS[name] ?? `icon_normal_${snake(name)}`;
  return { ref: `R.drawable.${res}` };
};

/** Web 아이콘 컴포넌트명(IconHeartFill) → 이름(heartFill) */
export const nameFromComponent = (component: string): string => {
  const n = component.replace(/^Icon/, '');
  return n.charAt(0).toLowerCase() + n.slice(1);
};
