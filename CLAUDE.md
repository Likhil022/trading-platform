# Trading Platform

Paper trading platform. Java 21, Spring Boot 3, Maven, PostgreSQL, Redis, Flyway.
Base package: com.yourname.trading

## Rules
- Modular monolith. Packages: auth, wallet, market, order, matching, portfolio, common.
- Modules must not access another module's repositories directly; use service interfaces or events.
- Schema changes only via Flyway migrations (ddl-auto=validate). Never edit applied migrations.
- Use BigDecimal for all money and quantities. Never double.
- Constructor injection only; Lombok allowed for getters/builders.
- DTOs for API requests/responses; never expose entities.
- Every feature needs unit tests (JUnit 5 + Mockito); integration tests use Testcontainers.
- Commit style: feat:, fix:, test:, chore:

## Commands
- docker compose up -d
- ./mvnw spring-boot:run
- ./mvnw test