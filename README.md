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
# 1. 기존 컨테이너 및 데이터 볼륨 삭제 (초기화 필요 시)
docker compose down -v

인프라 전체 실행 (백그라운드)
docker-compose up -d

# 실행 상태 확인
docker ps
```

### 3. 접속 확인

- Keycloak Admin: http://localhost:9090 (ID/PW: .env에 있는 값)
- Zipkin Dashboard: http://localhost:9411

---

## 🔐 테스트 계정 및 데이터 동기화

우리 프로젝트는 Keycloak의 유저 ID(UUID)와 서비스 DB의 유저 ID를 동기화하여 관리합니다.

아래 계정으로 즉시 테스트가 가능합니다.

- 공통 비밀번호: `123`
- 유저 목록

| Username | Role (X-User-Role) |
| -------- | ------------------ |
| admin    | ADMIN              |
| hub      | HUB_ADMIN          |
| delivery | DELIVERY           |
| company  | COMPANY            |

> 💡 매핑 원리: docker compose up 시 Keycloak은 realm-export.json을 통해 유저를 생성하고, Postgres는 init.sql을 통해 동일한 UUID를 가진 유저 데이터를 user_service.p_user 테이블에 미리 생성합니다

---

## 📮 Postman 테스트 가이드 (Token 발급)

Keycloak이 실행 중일 때, 별도의 백엔드 코드 없이도 Postman만으로 Access Token을 발급받아 API 권한 테스트를 할 수 있습니다.

### OAuth 2.0 설정

Postman의 Authorization 탭을 활용하면 토큰을 자동으로 관리할 수 있습니다.

- Auth Type: OAuth 2.0

- Token : KeyCloak-Token

- Header Prefix : Bearer

- Auto-refresh Token : On

- Grant Type: Password Credentials

- Access Token URL: http://localhost:9090/realms/da-it-da-realm/protocol/openid-connect/token

- Client ID: gateway-client

Username: admin (또는 hub, delivery, company)

Password: 123

설정 후: Get New Access Token -> Proceed -> Use Token

---

## 📂 폴더 구조 및 데이터 보관

- keycloak/import/: Keycloak 렐름 설정 및 유저 정보를 담은 realm-export.json이 위치합니다.
- postgres/init/: 컨테이너 최초 실행 시 실행될 초기 SQL 스크립트(init.sql 등)를 넣는 곳입니다.
- Data Persistence: DB 데이터는 Docker Named Volume(postgres_data, keycloak_data)에 저장됩니다.

## ⚠️ 주의사항

- 네트워크: 모든 컨테이너는 msa-net이라는 브릿지 네트워크로 묶여 있습니다. 서비스 간 통신 시 IP가 아닌 서비스 이름(postgres, redis 등)을 호스트명으로 사용하세요.
- 설정 변경 시: Keycloak 웹 콘솔에서 설정을 변경했다면, 반드시 export 명령어를 통해 realm-export.json을 최신화하고 공유해야 합니다.
