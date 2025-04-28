#/bin/bash

sourcedocs generate --clean --collapsible -r -o Documents --min-acl public -- -scheme Montage -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 16,OS=latest" -scmProvider system

# 문서 후처리: 파라미터와 반환값 형식 변환
if [ -d "Documents" ] && [ "$(ls -A Documents)" ]; then
  echo "Post-processing documentation..."

  # 임시 파일 생성
  find Documents -name "*.md" -exec sh -c '
    for file do
      # 임시 파일 생성
      temp_file=$(mktemp)

      # 파일 내용을 임시 파일에 복사
      cp "$file" "$temp_file"

      # 임시 파일을 처리하여 결과를 원본 파일에 저장
      awk "
        BEGIN {
          in_params=0;
          params_count=0;
          params_section=0;
          returns_section=0;
          returns_content=\"\";
          buffer=\"\";
          skip_original_params=0;
          skip_original_table=0;
        }

        # Returns 섹션 처리
        /- Returns:/ {
          returns_section=1;
          gsub(/- Returns: /, \"\", \$0);
          returns_content=\$0;
          next;
        }

        # 원본 Parameters 섹션 건너뛰기
        /#### Parameters/ {
          if (params_section == 0) {
            # 이미 처리된 Parameters 섹션인 경우 건너뛰기
            skip_original_params=1;
            skip_original_table=1;
            next;
          } else {
            # 새로 생성한 Parameters 섹션인 경우 출력
            print;
            next;
          }
        }

        # 원본 테이블 건너뛰기
        skip_original_table && /\| Name \| Description \|/ {
          next;
        }

        skip_original_table && /\| ---- \| ----------- \|/ {
          next;
        }

        skip_original_table && /^[[:space:]]*\| [^|]+ \| [^|]+ \|/ {
          next;
        }

        skip_original_table && /^[[:space:]]*$/ {
          skip_original_table=0;
          print;
          next;
        }

        skip_original_params && /^[[:space:]]*$/ {
          skip_original_params=0;
          print;
          next;
        }

        skip_original_params {
          next;
        }

        /- Parameters:/ {
          in_params=1;
          print \"#### Parameters\n\";
          print \"| Name | Description |\";
          print \"| ---- | ----------- |\";
          next;
        }

        in_params && /^[[:space:]]*- [^:]+:/ {
          param_name = \$2;
          gsub(/^[[:space:]]*- [^:]+: /, \"\", \$0);
          gsub(/:/, \"\", param_name);  # 콜론 제거
          print \"| \" param_name \" | \" \$0 \" |\";
          params_count++;
          next;
        }

        /- Parameter [^:]+:/ {
          if (!in_params) {
            in_params=1;
            print \"#### Parameters\n\";
            print \"| Name | Description |\";
            print \"| ---- | ----------- |\";
          }
          param_name = \$3;
          gsub(/^[[:space:]]*- Parameter [^:]+: /, \"\", \$0);
          gsub(/:/, \"\", param_name);  # 콜론 제거
          print \"| \" param_name \" | \" \$0 \" |\";
          params_count++;
          next;
        }

        in_params && /^[[:space:]]*$/ {
          in_params=0;
          if (params_count > 0) print \"\";
        }

        # Returns 섹션 출력
        /^[[:space:]]*$/ {
          if (returns_section) {
            print \"#### Returns\n\n\" returns_content;
            returns_section=0;
            print;
            next;
          }
        }

        { print; }
      " "$temp_file" > "$file"

      # 임시 파일 삭제
      rm "$temp_file"
    done
  ' sh {} +

  echo "Documentation generation completed successfully."
else
  echo "Documentation generation failed or no documentation was generated."
fi
