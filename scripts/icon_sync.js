const fs = require('fs');
const path = require('path');

const outputDir = './output';
const iconAssetsDir = './Sources/Montage/Asset/Icon.xcassets';
const swiftFilePath = './Sources/Montage/1 Components/9 Utilities/Icon.swift';

const main = async () => {
  const outputs = fs.readdirSync(outputDir);

  const icons = outputs.filter((filename) => filename.endsWith('.svg'));

  // clean up start
  const iconAssets = fs
    .readdirSync('./Sources/Montage/Asset/Icon.xcassets', 'utf8')
    .filter((iconAsset) => iconAsset.endsWith('.imageset'));

  iconAssets.forEach((iconAsset) => {
    const iconAssetPath = path.join('./Sources/Montage/Asset/Icon.xcassets', iconAsset);

    if (fs.existsSync(iconAssetPath)) {
      fs.rmSync(iconAssetPath, { recursive: true, force: true });
    }
  });
  // clean up end

  // sync files start
  outputs
    .filter((filename) => filename.endsWith('.svg'))
    .forEach((filename) => {
      const iconName = filename.replace(/\.svg$/, '');

      const svgContent = fs.readFileSync(path.join(outputDir, filename), 'utf8');

      fs.mkdirSync(path.join(iconAssetsDir, `${iconName}.imageset`));

      fs.writeFileSync(
        path.join(iconAssetsDir, `${iconName}.imageset`, 'Contents.json'),
        JSON.stringify(
          {
            images: [
              {
                filename: `${iconName}.svg`,
                idiom: 'universal'
              }
            ],
            info: {
              author: 'xcode',
              version: 1
            },
            properties: {
              'preserves-vector-representation': true,
              'template-rendering-intent': 'template'
            }
          },
          null,
          2
        ).replaceAll('":', '" :')
      );

      fs.writeFileSync(
        path.join(iconAssetsDir, `${iconName}.imageset`, `${iconName}.svg`),
        svgContent
          // 루트 <svg> 태그의 width/height만 제거(viewBox로 스케일). 안쪽 요소
          // (예: Opaque 아이콘의 흰색 <rect width="12" height="12">)의 크기는 보존한다.
          .replace(/<svg\b[^>]*>/, (svgTag) => svgTag.replace(/\s(?:width|height)="\d+"/g, ''))
          .replaceAll('fill="none"', '')
          .replaceAll('fill="#171719"', '')
      );
    });

  // sync files end

  // swift file update start
  let swiftFileContent = fs.readFileSync(swiftFilePath, 'utf8');

  const enumCases = icons
    .sort()
    .map((iconAsset) => `    case ${iconAsset.replace(/\.svg$/, '')}`)
    .join('\n');

  // Icon enum의 case 선언들만 정확히 찾아 대체하고, 다른 멤버(주석, 프로퍼티 등)는 유지합니다.
  swiftFileContent = swiftFileContent.replace(
    /(\n\s*public enum Icon: String, CaseIterable\s*\{\s*\n)([\s\S]*?)(\n\})/,
    (match, enumStart, existingCases, enumEnd) => {
      // 기존 케이스들 중에서 실제 case 선언만 필터링 (주석 등 제외)
      const oldCases = existingCases
        .split('\n')
        .filter((line) => line.trim().startsWith('case '))
        .join('\n');
      // 새로운 케이스 목록과 기존 케이스 목록이 다를 경우에만 업데이트
      if (
        oldCases !==
        enumCases
          .split('\n')
          .map((c) => c.trim())
          .join('\n')
      ) {
        return `${enumStart}${enumCases}${enumEnd}`;
      }
      // 케이스가 동일하면 원본 유지
      return match;
    }
  );

  fs.writeFileSync(swiftFilePath, swiftFileContent, 'utf-8');
  // swift file update end

  // remove output directory
  fs.rmSync(outputDir, { recursive: true, force: true });

  console.log('DONE!');
};

main();
