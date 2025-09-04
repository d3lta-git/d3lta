#!/bin/bash

echo ""
echo "================================"
echo " D3LTA - Despliegue Automático  "
echo "================================"
echo ""

echo "1. Construyendo la aplicación Flutter para web..."
flutter build web
if [ $? -ne 0 ]; then
    echo "Error al construir la aplicación Flutter."
    exit 1
fi

echo ""
echo "2. Copiando archivos construidos a la raíz del proyecto..."
cp -r build/web/* .
if [ $? -ne 0 ]; then
    echo "Error al copiar los archivos."
    exit 1
fi

echo ""
echo "3. Asegurándose de que .nojekyll existe..."
touch .nojekyll

echo ""
echo "4. Agregando cambios a Git..."
git add .
if [ $? -ne 0 ]; then
    echo "Error al agregar cambios a Git."
    exit 1
fi

echo ""
echo "5. Creando commit..."
git commit -m "Deploy: Actualización automática de la aplicación Flutter"
if [ $? -ne 0 ]; then
    echo "Error al crear el commit."
    exit 1
fi

echo ""
echo "6. Haciendo push a GitHub..."
git push origin main
if [ $? -ne 0 ]; then
    echo "Error al hacer push a GitHub."
    exit 1
fi

echo ""
echo "================================"
echo " Despliegue completado con éxito!"
echo "================================"
echo ""
echo "La aplicación se desplegará automáticamente en GitHub Pages en unos minutos."
echo "Puedes verificar en: https://d3lta.app"
echo ""
read -p "Presiona Enter para continuar..."