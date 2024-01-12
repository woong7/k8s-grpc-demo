# 시작 이미지로 공식 Go 이미지 사용
FROM golang:1.19 as builder

# 작업 디렉토리 설정
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

# 소스 코드 복사
COPY helloworld/ ./helloworld/
COPY greeter_server/ ./greeter_server/

# 서버 실행 파일 빌드
RUN CGO_ENABLED=0 GOOS=linux go build -o server ./greeter_server

# 최종 이미지
FROM alpine:latest  
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# 빌더 이미지에서 실행 파일 복사
COPY --from=builder /app/server .

# 서버 실행
CMD ["./server"]

