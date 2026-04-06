CREATE DATABASE keycloak_db;

CREATE SCHEMA IF NOT EXISTS user_service;
CREATE SCHEMA IF NOT EXISTS hub_service;
CREATE SCHEMA IF NOT EXISTS delivery_service;
CREATE SCHEMA IF NOT EXISTS delivery_manager_service;
CREATE SCHEMA IF NOT EXISTS company_service;
CREATE SCHEMA IF NOT EXISTS order_service;
CREATE SCHEMA IF NOT EXISTS notification_service;
CREATE SCHEMA IF NOT EXISTS product_service;

CREATE TABLE IF NOT EXISTS user_service.p_user (
    user_id UUID PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    slack_user_id VARCHAR(50) NOT NULL,
    hub_id UUID,
    company_id UUID,
    created_at TIMESTAMP,
    created_by UUID
);

-- Keycloak UUID 기반 테스트 데이터 삽입
INSERT INTO user_service.p_user (user_id, email, name, role, status, slack_user_id, created_at, created_by)
VALUES 
    ('245ab4e5-d35f-42a2-a820-ebd02deaa6fe', 'admin@admin.com', '관리자', 'ADMIN', 'APPROVED', 'SLACK_ADMIN_01', now(), '245ab4e5-d35f-42a2-a820-ebd02deaa6fe'),
    ('46f15747-9f66-4eaf-8f18-139f888a6223', 'hub@hub.com', '허브담당자', 'HUB_ADMIN', 'APPROVED', 'SLACK_HUB_01', now(), '46f15747-9f66-4eaf-8f18-139f888a6223'),
    ('132057a6-5501-46e9-9935-fd002be4a59a', 'delivery@delivery.com', '배송기사', 'DELIVERY', 'APPROVED', 'SLACK_DELIVERY_01', now(), '132057a6-5501-46e9-9935-fd002be4a59a'),
    ('65641afe-b93d-421f-a632-82e1ef507283', 'company@company.com', '업체주인', 'COMPANY', 'APPROVED', 'SLACK_COMPANY_01', now(), '65641afe-b93d-421f-a632-82e1ef507283')
ON CONFLICT (user_id) DO NOTHING;