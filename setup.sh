#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "========================================================="
echo "  SO-101 로보틱스 AI 위키 & 포트폴리오 원클릭 설치 스크립트"
echo "========================================================="
echo "설치 위치: $SCRIPT_DIR"
echo ""

# 1. OS 감지
OS="$(uname -s)"
case "$OS" in
  Linux*)     PLATFORM="linux";;
  Darwin*)    PLATFORM="mac";;
  CYGWIN*|MINGW*|MSYS*) PLATFORM="windows";;
  *)          PLATFORM="unknown";;
esac

echo "[1/3] 운영체제 감지: $PLATFORM ($OS)"

# 2. 옵시디언 설치 확인 및 자동 설치
if command -v obsidian &> /dev/null; then
  echo "  ✓ 옵시디언이 이미 시스템에 설치되어 있습니다."
else
  echo "  ! 옵시디언이 설치되어 있지 않습니다. 설치를 진행합니다..."
  if [ "$PLATFORM" = "linux" ]; then
    ARCH="$(uname -m)"
    if [ "$ARCH" = "x86_64" ]; then
      echo "  -> 최신 Obsidian DEB 패키지를 다운로드하여 사용자 로컬 환경(~/.local)에 설치합니다..."
      mkdir -p ~/.local/bin ~/.local/opt/obsidian ~/.local/share/applications ~/.local/share/icons/hicolor
      TEMP_DEB="/tmp/obsidian_install.deb"
      curl -fsSL https://github.com/obsidianmd/obsidian-releases/releases/download/v1.13.7/obsidian_1.13.7_amd64.deb -o "$TEMP_DEB"
      dpkg -x "$TEMP_DEB" ~/.local/opt/obsidian
      rm -f "$TEMP_DEB"
      
      # 래퍼 스크립트 생성 (no-sandbox 지원)
      cat << 'WRAPPER' > ~/.local/bin/obsidian
#!/usr/bin/env bash
exec ~/.local/opt/obsidian/opt/Obsidian/obsidian --no-sandbox "$@"
WRAPPER
      chmod +x ~/.local/bin/obsidian
      
      # 아이콘 및 데스크톱 런처 복사
      cp -r ~/.local/opt/obsidian/usr/share/icons/* ~/.local/share/icons/ 2>/dev/null || true
      sed -e 's|Exec=obsidian|Exec='"$HOME"'/.local/bin/obsidian|g' \
          ~/.local/opt/obsidian/usr/share/applications/md.obsidian.Obsidian.desktop \
          > ~/.local/share/applications/md.obsidian.Obsidian.desktop 2>/dev/null || true
      chmod +x ~/.local/share/applications/md.obsidian.Obsidian.desktop 2>/dev/null || true
      
      echo "  ✓ 옵시디언 설치 완료! (~/.local/bin/obsidian)"
    else
      echo "  x 지원하지 않는 아키텍처($ARCH)입니다. https://obsidian.md 에서 수동 설치를 권장합니다."
    fi
  elif [ "$PLATFORM" = "mac" ]; then
    if command -v brew &> /dev/null; then
      echo "  -> Homebrew를 통해 옵시디언을 설치합니다: brew install --cask obsidian"
      brew install --cask obsidian
    else
      echo "  ! Mac 사용자는 https://obsidian.md 에서 Obsidian.dmg를 다운로드해 설치해주세요."
    fi
  elif [ "$PLATFORM" = "windows" ]; then
    if command -v winget &> /dev/null; then
      echo "  -> winget을 통해 옵시디언을 설치합니다: winget install Obsidian.Obsidian"
      winget install Obsidian.Obsidian
    else
      echo "  ! Windows 사용자는 https://obsidian.md 에서 설치 파일을 다운로드해 설치해주세요."
    fi
  fi
fi

# 3. AI CLI 설정 자동 승인(autoApprove) 감지 및 구성
echo ""
echo "[2/3] AI CLI 자동 승인 권한(autoApprove) 설정 점검..."
GEMINI_SETTINGS="$HOME/.gemini/antigravity-cli/settings.json"
if [ -f "$GEMINI_SETTINGS" ]; then
  python3 -c "
import json
p = '$GEMINI_SETTINGS'
try:
    with open(p, 'r', encoding='utf-8') as f: d = json.load(f)
    if 'permissions' not in d: d['permissions'] = {}
    d['permissions']['autoApprove'] = True
    with open(p, 'w', encoding='utf-8') as f: json.dump(d, f, indent=2, ensure_ascii=False)
    print('  ✓ Antigravity CLI autoApprove 설정이 완료되었습니다.')
except Exception as e:
    print('  ! 설정 변경 중 건너뜀:', e)
" 2>/dev/null || true
else
  echo "  - Antigravity CLI 설정 파일이 없어 건너뜁니다."
fi

# 4. 완료 안내
echo ""
echo "[3/3] 위키 무결성 점검..."
"$SCRIPT_DIR/scripts/validate-template.sh"

echo ""
echo "========================================================="
echo "  🎉 설치 및 설정이 성공적으로 완료되었습니다!"
echo "========================================================="
echo ""
echo "  [사용 방법]"
echo "  1. 옵시디언(Obsidian)을 실행합니다."
echo "  2. 'Open folder as vault' (폴더를 보관함으로 열기)를 누르고"
echo "     아래 경로를 선택합니다:"
echo "     -> $SCRIPT_DIR"
echo ""
echo "  3. 터미널이나 에디터(Claude Code, Codex, Antigravity)에서 작업 시:"
echo "     - '이번 작업 내용 옵시디언에 저장해줘' (save)"
echo "     - '옵시디언 참조해줘' (query)"
echo "     명령어로 실시간 포트폴리오 관리가 동작합니다."
echo "========================================================="
