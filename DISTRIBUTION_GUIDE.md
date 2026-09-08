# 다른 컴퓨터에 배포 및 설치하는 방법 (Distribution Guide)

이 위키 패키지를 다른 컴퓨터(노트북, 연구실 PC, 데스크톱 등)에서도 동일하게 설치하고 사용하실 수 있도록 **2가지 배포 방식**과 **원클릭 설치 스크립트(`setup.sh`)**를 제공합니다.

---

## 🚀 방법 1: GitHub을 통한 배포 (가장 추천)

GitHub에 프라이빗 또는 퍼블릭 리포지토리로 올려두면, 다른 컴퓨터에서 코드 한 줄로 설치 및 동기화할 수 있습니다.

### 1) 현재 컴퓨터에서 GitHub으로 올리기 (최초 1회)
1. [GitHub](https://github.com)에서 새 빈 리포지토리 생성 (예: `ai-agent-wiki` 또는 `so101-robotics-wiki`)
2. 현재 터미널에서 아래 명령어 실행:
   ```bash
   cd ~/AI-Agent-Wiki
   git remote add origin https://github.com/사용자이름/리포지토리이름.git
   git branch -M main
   git push -u origin main
   ```

### 2) 다른 컴퓨터에서 설치하기
새 컴퓨터의 터미널에서 아래 명령어만 실행하면 끝납니다:
```bash
git clone https://github.com/사용자이름/리포지토리이름.git ~/AI-Agent-Wiki
cd ~/AI-Agent-Wiki
./setup.sh
```
*(자동으로 OS를 감지하고 옵시디언 설치 및 에이전트 환경 세팅까지 완료됩니다.)*

---

## 📦 방법 2: 압축 파일(Zip / USB)로 배포

인터넷 GitHub 연결 없이 USB나 클라우드 드라이브로 배포하고 싶을 때 사용합니다.

### 1) 패키지 압축 파일 생성하기
현재 컴퓨터 홈 디렉토리에 **`AI-Agent-Wiki-Package.zip`** 파일이 이미 생성되어 있습니다:
- 위치: `~/AI-Agent-Wiki-Package.zip`

### 2) 다른 컴퓨터에서 압축 풀고 설치하기
1. `AI-Agent-Wiki-Package.zip` 파일을 새 컴퓨터의 홈 디렉토리(`~`)로 복사합니다.
2. 터미널에서 압축을 풀고 설치 스크립트를 실행합니다:
   ```bash
   unzip AI-Agent-Wiki-Package.zip -d ~/AI-Agent-Wiki
   cd ~/AI-Agent-Wiki
   ./setup.sh
   ```

---

## 💻 지원 운영체제 (OS별 설치 과정)

`setup.sh` 스크립트는 운영체제를 자동 감지합니다:

- **Ubuntu / Debian Linux**: 
  - `sudo` 권한 없이도 사용자 로컬 환경(`~/.local/bin`, `~/.local/opt`)에 옵시디언 최신 버전과 앱 런처를 자동 설치합니다.
- **macOS**: 
  - Homebrew가 있을 경우 `brew install --cask obsidian`을 자동 실행합니다.
- **Windows (WSL / Git Bash)**:
  - `winget install Obsidian.Obsidian`을 안내하거나 자동 실행합니다.

---

## 🎯 설치 완료 후 공통 작업

1. 옵시디언 실행 $\rightarrow$ **Open folder as vault** (폴더를 보관함으로 열기) 클릭
2. 방금 설치된 `AI-Agent-Wiki` 폴더를 선택하고 열기
3. AI 에이전트(Claude Code, Codex, Antigravity 등)에서:
   - *"이번 작업 내용 옵시디언에 저장해줘"*
   - *"옵시디언 참조해줘"*
   자연어로 포트폴리오를 계속해서 누적하시면 됩니다!
