CREATE TABLE users (
                       id            UUID PRIMARY KEY,
                       email         VARCHAR(255) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role          VARCHAR(20)  NOT NULL DEFAULT 'USER',
                       created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE wallets (
                         id         UUID PRIMARY KEY,
                         user_id    UUID NOT NULL UNIQUE REFERENCES users(id),
                         balance    NUMERIC(19,4) NOT NULL CHECK (balance >= 0),
                         held       NUMERIC(19,4) NOT NULL DEFAULT 0 CHECK (held >= 0),
                         version    BIGINT NOT NULL DEFAULT 0,
                         updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE wallet_ledger (
                               id         UUID PRIMARY KEY,
                               wallet_id  UUID NOT NULL REFERENCES wallets(id),
                               entry_type VARCHAR(20) NOT NULL,
                               amount     NUMERIC(19,4) NOT NULL,
                               reference  VARCHAR(100),
                               created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_ledger_wallet ON wallet_ledger(wallet_id, created_at DESC);

CREATE TABLE orders (
                        id              UUID PRIMARY KEY,
                        user_id         UUID NOT NULL REFERENCES users(id),
                        symbol          VARCHAR(20) NOT NULL,
                        side            VARCHAR(4)  NOT NULL,
                        order_type      VARCHAR(10) NOT NULL,
                        quantity        NUMERIC(19,8) NOT NULL CHECK (quantity > 0),
                        price           NUMERIC(19,8),
                        filled_quantity NUMERIC(19,8) NOT NULL DEFAULT 0,
                        status          VARCHAR(20) NOT NULL,
                        idempotency_key VARCHAR(100) NOT NULL,
                        version         BIGINT NOT NULL DEFAULT 0,
                        created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
                        updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
                        UNIQUE (user_id, idempotency_key)
);
CREATE INDEX idx_orders_user ON orders(user_id, created_at DESC);
CREATE INDEX idx_orders_open ON orders(symbol, status);

CREATE TABLE trades (
                        id               UUID PRIMARY KEY,
                        order_id         UUID NOT NULL REFERENCES orders(id),
                        counter_order_id UUID REFERENCES orders(id),
                        symbol           VARCHAR(20) NOT NULL,
                        price            NUMERIC(19,8) NOT NULL,
                        quantity         NUMERIC(19,8) NOT NULL,
                        executed_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_trades_order ON trades(order_id);

CREATE TABLE holdings (
                          id         UUID PRIMARY KEY,
                          user_id    UUID NOT NULL REFERENCES users(id),
                          symbol     VARCHAR(20) NOT NULL,
                          quantity   NUMERIC(19,8) NOT NULL CHECK (quantity >= 0),
                          avg_price  NUMERIC(19,8) NOT NULL,
                          version    BIGINT NOT NULL DEFAULT 0,
                          UNIQUE (user_id, symbol)
);