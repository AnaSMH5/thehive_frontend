# Usa una imagen base con nginx
FROM nginx:alpine

# Elimina el contenido HTML por defecto de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia los archivos del build de Flutter Web
COPY ./build/web /usr/share/nginx/html

# Expone el puerto 80 (puerto por defecto de nginx)
EXPOSE 8000

# Arranca nginx en modo foreground
CMD ["nginx", "-g", "daemon off;"]