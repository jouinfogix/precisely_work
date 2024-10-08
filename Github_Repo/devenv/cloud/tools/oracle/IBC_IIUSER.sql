-- II upgrade SQL to be executed at the beginning of the upgrade.
-- 

-- Deletes the constraint and JOBDEFDTL_JSQP_IDX index
ALTER TABLE "JOBDEFINITIONDETAIL"
    DROP CONSTRAINT "JOBDEFDTL_JSQP_UNQ" DROP INDEX;
 COMMIT;

-- Now add the constraint back
ALTER TABLE "JOBDEFINITIONDETAIL"
    ADD CONSTRAINT "JOBDEFDTL_JSQP_UNQ" UNIQUE ("JOB","STEP","QUALIFIER","PLATFORMID");
COMMIT;

-- Add the JOBDEFDTL Index back with an additional constant column
-- Oracle doesn't allow redundant indexes


------ JOBDEFINITIONSUMMARY
-- Delete the constraint and JOBDEFSUMM_JS_IDX
ALTER TABLE "JOBDEFINITIONSUMMARY"
    DROP CONSTRAINT JOBDEFSUMM_JS_UNQ DROP INDEX;
COMMIT;

-- Now add it back
ALTER TABLE "JOBDEFINITIONSUMMARY"
    ADD CONSTRAINT "JOBDEFSUMM_JS_UNQ" UNIQUE ("JOB","STEP","QUALIFIER","PLATFORMID");
COMMIT;

-- Add the index with an additional column

-- JOBDETAILTOCONTROLGROUP
-- The constraint references a foreign key so we have to drop that first
ALTER TABLE "CGRULES_JOBDEFDTL"
    DROP CONSTRAINT CGRULES_JD_GJ_FK;
COMMIT;

-- Delete the constraint and JOBDTL2CG_IDX
ALTER TABLE "JOBDETAILTOCONTROLGROUP"
    DROP CONSTRAINT JOBDTL2CG_UNQ DROP INDEX;
COMMIT;

-- Now add it back
ALTER TABLE "JOBDETAILTOCONTROLGROUP"
    ADD CONSTRAINT "JOBDTL2CG_UNQ" UNIQUE ("CONTROLGROUPFK","JOBFK");
COMMIT;

-- Add the index with an additional column
-- Add the CGRULES_JD_GJ_FK back
ALTER TABLE "CGRULES_JOBDEFDTL"
    ADD CONSTRAINT "CGRULES_JD_GJ_FK" FOREIGN KEY
(
    "CONTROLGROUPFK",
    "JOBFK"
) REFERENCES "JOBDETAILTOCONTROLGROUP"("CONTROLGROUPFK", "JOBFK");
COMMIT;

--- JOBSUMMTOCONTROLGROUP
-- Delete the referenced foreign constraint
ALTER TABLE "CGRULES_JOBDEFSUMM"
    DROP CONSTRAINT CGRULES_JS_GJ_FK;
COMMIT;

-- Delete the constraint and JOBSUM2CG_IDX
ALTER TABLE "JOBSUMMTOCONTROLGROUP"
    DROP CONSTRAINT JOBSUM2CG_UNQ DROP INDEX;
COMMIT;

-- Now add it back
ALTER TABLE "JOBSUMMTOCONTROLGROUP"
    ADD CONSTRAINT "JOBSUM2CG_UNQ" UNIQUE ("CONTROLGROUPFK","JOBFK");
COMMIT;

-- Add the index with an additional column

-- Now add back CGRULES_JS_GJ_FK
ALTER TABLE "CGRULES_JOBDEFSUMM"
    ADD CONSTRAINT "CGRULES_JS_GJ_FK" FOREIGN KEY
(
    "CONTROLGROUPFK",
    "JOBFK"
) REFERENCES "JOBSUMMTOCONTROLGROUP"("CONTROLGROUPFK", "JOBFK");
COMMIT;

--- CYCLEDETAIL
-- Delete the constraint and CYCLEDTL_CYC_IDX
ALTER TABLE "CYCLEDETAIL"
    DROP CONSTRAINT CYCLEDTL_CYC_UNQ DROP INDEX;
COMMIT;

-- Now add it back
ALTER TABLE "CYCLEDETAIL"
    ADD CONSTRAINT "CYCLEDTL_CYC_UNQ" UNIQUE ("CYCLE");
COMMIT;

-- Add the index with an additional column


--- CYCLESUMMARY
-- Delete the constraint and CYCSUM_CYCRUN_IDX
ALTER TABLE "CYCLESUMMARY"
    DROP CONSTRAINT CYCSUM_CYCRUN_UNQ DROP INDEX;
COMMIT;

ALTER TABLE "CYCLESUMMARY"
    ADD CONSTRAINT CYCSUM_CYCRUN_UNQ UNIQUE ("CYCLE","RUNNUMBER");
COMMIT;
    

--- KEYDETAIL
-- Delete the constraint and KEYDETAIL_IDX
ALTER TABLE "KEYDETAIL"
    DROP CONSTRAINT KEYDETAIL_UNQ DROP INDEX;
COMMIT;

ALTER TABLE "KEYDETAIL"
    ADD CONSTRAINT KEYDETAIL_UNQ UNIQUE ("KEY");
COMMIT;

-- KEYRCDETAIL
-- Delete the constraint and KEYDETAIL_IDX
ALTER TABLE "KEYRCDETAIL"
    DROP CONSTRAINT KEYRCDETAIL_UNQ DROP INDEX;
COMMIT;

-- Now add it back
ALTER TABLE "KEYRCDETAIL"
    ADD CONSTRAINT KEYRCDETAIL_UNQ UNIQUE ("JOBFK","KEYFK","CYCLEFK");
COMMIT;

-- Add the index with an additional column

DROP TABLE SESSION_KEY;
COMMIT;

CREATE TABLE SESSION_KEY
(
    SESSION_KEYPK NUMBER(20) NOT NULL,
    SESSION_KEY VARCHAR(512) NOT NULL,
    SESSION_IV VARCHAR(512) NOT NULL,
    RSA_ALIAS VARCHAR(100) NOT NULL
)
TABLESPACE II_SECURITY PCTFREE 10 STORAGE (INITIAL 1M NEXT 1M MINEXTENTS 1 MAXEXTENTS 10 PCTINCREASE 0);
COMMIT;








