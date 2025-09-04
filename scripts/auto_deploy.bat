@echo off
echo.
echo ================================
echo  D3LTA - Despliegue Automtico  
echo ================================
echo.

echo 1. Construyendo la aplicacin Flutter para web...
flutter build web
if %errorlevel% neq 0 (
    echo Error al construir la aplicacin Flutter.
    exit /b %errorlevel%
)

echo.
echo 2. Copiando archivos construidos a la raz del proyecto...
xcopy build\web . /E /Y /Q
if %errorlevel% neq 0 (
    echo Error al copiar los archivos.
    exit /b %errorlevel%
)

echo.
echo 3. Asegurndose de que .nojekyll existe...
if not exist .nojekyll (
    echo. > .nojekyll
)

echo.
echo 4. Agregando cambios a Git...
git add .
if %errorlevel% neq 0 (
    echo Error al agregar cambios a Git.
    exit /b %errorlevel%
)

echo.
echo 5. Creando commit...
git commit -m "Deploy: Actualizacin automtica de la aplicacin Flutter"
if %errorlevel% neq 0 (
    echo Error al crear el commit.
    exit /b %errorlevel%
)

echo.
echo 6. Haciendo push a GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo Error al hacer push a GitHub.
    exit /b %errorlevel%
)

echo.
echo ================================
echo  Despliegue completado con xito!
echo ================================
echo.
echo La aplicacin se desplegar automticamente en GitHub Pages en unos minutos.
echo Puedes verificar en: https://d3lta.app
echo.
pause