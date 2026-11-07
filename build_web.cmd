@echo off
rem =========================================================================
rem High Performance and Secure Production Web Build Script (Windows CMD)
rem =========================================================================

chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo =========================================================================
echo  Production Web Build Process Started
echo =========================================================================
echo.

rem [1/5] Clean and get dependencies
echo 🚀 [1/5] Cleaning and Fetching Dependencies...
call flutter clean
if %ERRORLEVEL% neq 0 (
echo ❌ [Error] 'flutter clean' failed with exit code %ERRORLEVEL%.
exit /b %ERRORLEVEL%
)

call flutter pub get
if %ERRORLEVEL% neq 0 (
echo ❌ [Error] 'flutter pub get' failed with exit code %ERRORLEVEL%.
exit /b %ERRORLEVEL%
)

rem [2/5] Strict code quality audit
echo.
echo 🔍 [2/5] Strict Code Quality Audit (Linter)...
call flutter analyze --fatal-infos
if %ERRORLEVEL% neq 0 (
echo ❌ [Error] 'flutter analyze --fatal-infos' detected issues/hints! Build aborted.
exit /b %ERRORLEVEL%
)

rem [3/5] Automated test suite execution
echo.
echo 🧪 [3/5] Running Automated Test Suite...
call flutter test
if %ERRORLEVEL% neq 0 (
echo ❌ [Error] 'flutter test' failed! Build aborted.
exit /b %ERRORLEVEL%
)

rem [4/5] Build release web with security and performance flags
echo.
echo 🛠️ [4/5] Building High-Performance Web Release...
rem --release: Enables maximum Minification and Tree-Shaking
rem --no-source-maps: Prevents source maps generation to protect code structure
rem --base-href /kartiq/: Sets deployment base path
call flutter build web --wasm --release -O4 --no-source-maps --tree-shake-icons --base-href / 
rem --base-href /kartiq/
if %ERRORLEVEL% neq 0 (
echo ❌ [Error] Web build failed with exit code %ERRORLEVEL%.
exit /b %ERRORLEVEL%
)

rem [5/5] Completion notification
echo.
echo ✅ [5/5] Web Build Completed Successfully! Output in build\web
echo =========================================================================
echo.

exit /b 0
