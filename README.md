# Adminer Custom Docker Image

Esta es una imagen personalizada de [Adminer](https://www.adminer.org/) diseñada para mejorar la experiencia de usuario y añadir soporte para bases de datos modernas.

## Características

- **Tema Dracula**: Una interfaz oscura y elegante basada en el popular tema [Dracula](https://draculatheme.com/adminer).
- **Soporte MongoDB**: Incluye la extensión nativa de PHP para MongoDB y el driver correspondiente en Adminer.
- **Automatización CI/CD**: Incluye un workflow de GitHub Actions para construir y subir la imagen automáticamente.
- **Plugins Incluidos**:
  - `config`: Permite guardar configuraciones (como el diseño) en cookies.
  - `favorite-query`: Permite guardar tus consultas SQL favoritas en el almacenamiento local del navegador.
- **Optimizado**: Configuración limpia mediante cargadores manuales para evitar errores de interfaz y asegurar que todos los componentes se registren correctamente.

## Requisitos

- [Docker](https://www.docker.com/) instalado.

## Comandos Útiles

### 1. Construir la imagen localmente

Desde la raíz del proyecto, ejecuta:

```bash
docker build -t adminer-custom .
```

### 2. Ejecutar el contenedor

Para iniciar Adminer en el puerto `8080`:

```bash
docker run -d -p 8080:8080 --name my-adminer adminer-custom
```

Luego accede a [http://localhost:8080](http://localhost:8080).

### 3. Subir a Docker Hub

Para guardar esta imagen en tu propio repositorio de Docker Hub:

```bash
# Iniciar sesión
docker login

# Etiquetar la imagen (reemplaza <usuario> con tu nombre de usuario de Docker Hub)
docker tag adminer-custom <usuario>/adminer-custom:latest

# Subir la imagen
docker push <usuario>/adminer-custom:latest
```

## Despliegue Automático (GitHub Actions)

Este repositorio incluye un pipeline que construye y sube la imagen a Docker Hub automáticamente en cada `push` a las ramas `main` o `master`.

Para que funcione, debes configurar los siguientes **Secrets** en tu repositorio de GitHub (`Settings > Secrets and variables > Actions`):

1. `DOCKERHUB_USERNAME`: Tu nombre de usuario de Docker Hub.
2. `DOCKERHUB_TOKEN`: Un [Access Token](https://docs.docker.com/docker-hub/access-tokens/) de Docker Hub (más seguro que usar tu contraseña).

## Estructura del Proyecto

- `Dockerfile`: Configuración de la imagen basada en `adminer:latest`.
- `adminer.css`: Archivo de estilos para el tema Dracula.
- `plugins/`: Directorio con los archivos PHP de los plugins adicionales.
- `plugins-enabled/`: (Generado en el build) Contiene los cargadores de los plugins activos.

## Notas Técnicas

- La imagen utiliza **Alpine Linux** como base para mantener un tamaño reducido.
- Se ha corregido un problema común donde el driver de MongoDB no se cargaba automáticamente al usar plugins personalizados.
- El usuario por defecto dentro del contenedor es `adminer` por motivos de seguridad.
