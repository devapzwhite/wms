class Workorder {}



/*

CREATE TABLE work_orders (
    id                   SERIAL PRIMARY KEY,
    shop_id              INTEGER NOT NULL REFERENCES workshops(id) ON DELETE CASCADE,
    vehicle_id           INTEGER NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
    created_by_user_id   INTEGER REFERENCES users(id),
    check_in_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    check_out_at         TIMESTAMP,
    initial_diagnosis    TEXT,
    labor_estimate       NUMERIC(12,2) default 0,
    parts_estimate       NUMERIC(12,2) default 0,
    status               VARCHAR(30) NOT NULL
        CHECK (status IN (
            'RECEIVED',
            'DIAGNOSIS',
            'WAITING_APPROVAL',
            'APPROVED',
            'IN_PROGRESS',
            'WAITING_PARTS',
            'REPAIRED',
            'READY_FOR_DELIVERY',
            'COMPLETED',
            'CANCELLED'
        )),
    notes                TEXT,
    created_at           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

*/