# Etapa 1: build del frontend Flutter web
FROM dart:stable as build

WORKDIR /app

# Copia todo el frontend
COPY frontend/ .

RUN flutter pub get

ARG API_URL
RUN flutter build web --dart-define=API_URL=$API_URL

# Etapa 2: servir archivos con un servidor simple (nginx o python)
FROM nginx:stable-alpine

# Borra archivos por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia archivos compilados del build anterior
COPY --from=build /app/build/web /usr/share/nginx/html

# Expone el puerto para servir
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]