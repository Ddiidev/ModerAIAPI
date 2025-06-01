# Estágio de build
FROM thevlang/vlang:latest AS builder

WORKDIR /app

COPY . .

# Compilar a aplicação Vlang
# Usamos -prod para otimização de produção e -enable-globals para compatibilidade
RUN v -prod -enable-globals -o moderai-api main.v

# Estágio final - imagem mínima para servir a aplicação
FROM alpine:latest

WORKDIR /app

# Copiar o binário compilado do estágio de build
COPY --from=builder /app/moderai-api .

# Expor a porta que a aplicação Vlang escuta
EXPOSE 4242

# Definir variáveis de ambiente
ENV V_THREADS=8
ENV PORT=4242

# Comando para executar a aplicação
CMD ["./moderai-api"]