const fs = require('fs');
const path = require('path');
const { BATCH_PATH, buildIconBatch, iconNamesInBatch, assertSameNames } = require('./icon_code_connect_batch');

const outputDir = './output';
const iconAssetsDir = './Sources/Montage/Asset/Icon.xcassets';
const swiftFilePath = './Sources/Montage/1 Components/9 Utilities/Icon.swift';

const main = async () => {
  const outputs = fs.readdirSync(outputDir);

  const icons = outputs.filter((filename) => filename.endsWith('.svg'));

  // Code Connect 아이콘 batch는 파일을 건드리기 전에 만들고 검증한다.
  // result.json이 없거나 SVG 목록과 어긋나면 여기서 멈춰 에셋·enum만 바뀐 커밋이 생기지 않게 한다.
  const resultPath = path.join(outputDir, 'result.json');
  if (!fs.existsSync(resultPath)) {
    throw new Error(`${resultPath}가 없어 Code Connect 아이콘 batch를 만들 수 없습니다.`);
  }
  const iconBatch = buildIconBatch(JSON.parse(fs.readFileSync(resultPath, 'utf8')));
  assertSameNames(
    icons.map((filename) => filename.replace(/\.svg$/, '')),
    iconNamesInBatch(iconBatch),
    'SVG',
    'result.json'
  );

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

  // Code Connect 아이콘 batch 갱신 (figma/README.md 참고)
  fs.writeFileSync(BATCH_PATH, iconBatch, 'utf-8');

  // remove output directory
  fs.rmSync(outputDir, { recursive: true, force: true });

  console.log('DONE!');
};

// 실패하면 exit code를 1로 남겨 워크플로가 커밋 단계로 넘어가지 않게 한다.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
