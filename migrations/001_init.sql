CREATE TABLE wallets (
    id UUID PRIMARY KEY,
    balance BIGINT NOT NULL CHECK(balance >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE transfers (
    id UUID PRIMARY KEY,

    idempotency_key VARCHAR(255) NOT NULL UNIQUE,

    from_wallet_id UUID NOT NULL REFERENCES wallets(id),
    to_wallet_id UUID NOT NULL REFERENCES wallets(id),

    amount BIGINT NOT NULL CHECK(amount > 0),

    state VARCHAR(20) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transfers_idempotency
ON transfers(idempotency_key);

CREATE TABLE ledger_entries (
    id UUID PRIMARY KEY,

    transfer_id UUID NOT NULL REFERENCES transfers(id),

    wallet_id UUID NOT NULL REFERENCES wallets(id),

    entry_type VARCHAR(10) NOT NULL,

    amount BIGINT NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ledger_transfer
ON ledger_entries(transfer_id);