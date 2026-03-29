## 🛠️ MSA Infrastructure Repository (infra-repo)

이 레포지토리는 우리 프로젝트의 공통 인프라(DB, Cache, Auth, Tracing)를 Docker Compose로 관리하는 통합 환경입니다. 모든 마이크로서비스를 실행하기 전, 이 인프라가 먼저 구동되어야 합니다.

## 🏗️ 포함된 서비스 (Infrastructure Stack)

| 서비스     | 이미지 (Version) | 외부 포트 | 설명                                     |
| ---------- | ---------------- | --------- | ---------------------------------------- |
| PostgreSQL | postgres:17      | 5432      | 메인 데이터베이스 (Keycloak 데이터 포함) |
| Redis      | redis:7-alpine   | 6379      | 분산 캐시 및 메시지 브로커               |
| Keycloak   | keycloak:26.5.6  | 9090      | IAM (인증 및 인가 서버)                  |
| Zipkin     | zipkin:latest    | 9411      | 분산 트레이싱 (로그 추적)                |

## 🚀 시작하기 (Quick Start)

### 1. 환경 변수 설정

보안을 위해 .env 파일은 Git에 포함되지 않습니다. 루트 폴더에 .env 파일을 생성하고 공유된 내용을 복사하세요.

### 2. 인프라 실행

Docker Desktop이 실행 중인지 확인한 후, 터미널에서 아래 명령어를 입력합니다.

```
인프라 전체 실행 (백그라운드)
docker-compose up -d

# 실행 상태 확인
docker ps
```

### 3. 접속 확인

- Keycloak Admin: http://localhost:9090 (ID/PW: .env에 있는 값)
- Zipkin Dashboard: http://localhost:9411

## 📂 폴더 구조 및 데이터 보관

- postgres/init/: 컨테이너 최초 실행 시 실행될 초기 SQL 스크립트(init.sql 등)를 넣는 곳입니다.
- Data Persistence: DB 데이터는 Docker의 Named Volume(postgres_data)에 저장되므로, 컨테이너를 삭제해도 데이터는 유지됩니다.

## ⚠️ 주의사항

- 네트워크: 모든 컨테이너는 msa-net이라는 브릿지 네트워크로 묶여 있습니다. 서비스 간 통신 시 IP가 아닌 서비스 이름(postgres, redis 등)을 호스트명으로 사용하세요.
