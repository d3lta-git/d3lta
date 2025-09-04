# Despliegue Automático de D3LTA

## Scripts de Despliegue

Este proyecto incluye scripts para automatizar el despliegue a GitHub Pages:

### En Windows
```bash
scripts\auto_deploy.bat
```

### En macOS/Linux
```bash
chmod +x scripts/auto_deploy.sh
./scripts/auto_deploy.sh
```

## Atajos de Teclado en VS Code

- `Ctrl+Shift+D`: Desplegar a GitHub Pages
- `Ctrl+Shift+B`: Construir la aplicación Flutter para web

## Proceso de Despliegue Automático

El script realiza automáticamente los siguientes pasos:

1. Construye la aplicación Flutter para web
2. Copia los archivos construidos a la raíz del proyecto
3. Asegura que el archivo `.nojekyll` exista
4. Agrega todos los cambios a Git
5. Crea un commit con un mensaje descriptivo
6. Hace push a la rama main en GitHub

GitHub Pages se actualizará automáticamente en unos minutos después del push.

## Verificación

Después del despliegue, puedes verificar que los cambios se hayan aplicado visitando:
- https://d3lta.app
- https://www.d3lta.app