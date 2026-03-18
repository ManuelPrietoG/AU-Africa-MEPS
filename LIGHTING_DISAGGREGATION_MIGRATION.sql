-- ============================================================
-- AU-AFR-MEPS Dashboard: Lighting Product-Type Disaggregation
-- Migration: Add per-technology lighting fields to country data
-- Author: HEAT GmbH / FOXTROT Squad
-- Date: 2026-03-18
-- ============================================================
--
-- BACKGROUND: Phase 1 reviewers (#147, #199, #215, #203) requested
-- disaggregation of lighting MEPS by product type. This migration adds
-- five new columns to support LED, T8 fluorescent, street lighting,
-- incandescent ban status, and CFL/mercury ban status.
--
-- RUN IN: Supabase SQL editor (Dashboard → SQL → New query)
-- ============================================================

-- Step 1: Add new columns
ALTER TABLE meps_country_data
  ADD COLUMN IF NOT EXISTS lighting_led_min        NUMERIC,      -- Minimum LED efficacy (lm/W)
  ADD COLUMN IF NOT EXISTS lighting_t8_min         NUMERIC,      -- Minimum T8 fluorescent efficacy (lm/W)
  ADD COLUMN IF NOT EXISTS lighting_street_min     NUMERIC,      -- Minimum street lighting efficacy (lm/W)
  ADD COLUMN IF NOT EXISTS lighting_cfl_banned     BOOLEAN DEFAULT FALSE,  -- CFL banned (Minamata / national)
  ADD COLUMN IF NOT EXISTS lighting_incandescent_banned BOOLEAN DEFAULT FALSE; -- Incandescent banned

-- Step 2: Populate data for priority countries
-- Sources: KEBS, SANS, AMEE, ANME, ECOWAS Lighting Directive (2016),
--          EAC EAS 776:2022, U4E Model Regulation Guidelines

UPDATE meps_country_data SET
  lighting_led_min = 80,
  lighting_incandescent_banned = TRUE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Egypt';
-- Source: Egyptian Energy Efficiency Label (NREA/CCME, 2019), IEC 62612 aligned

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = TRUE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Ghana';
-- Source: ECOWAS LED Directive (2016) + PURC enforcement (2020)

UPDATE meps_country_data SET
  lighting_led_min = 80,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Kenya';
-- Source: KEBS KS EAS 776:2022, IE Class LED MEPS

UPDATE meps_country_data SET
  lighting_led_min = 80,
  lighting_incandescent_banned = TRUE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Morocco';
-- Source: AMEE Programme Éclairage Efficace, ban enacted 2020

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Nigeria';
-- Source: SON + ECOWAS Directive (2016); national enforcement still maturing

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Rwanda';
-- Source: REG/EAC EAS 776:2022 alignment

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Senegal';
-- Source: ECOWAS Directive (2016); CRSE adoption in progress

UPDATE meps_country_data SET
  lighting_led_min = 80,
  lighting_t8_min = 60,
  lighting_incandescent_banned = TRUE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'South Africa';
-- Source: SANS 941:2021 (LED ≥80 lm/W), SANS 60081 (T8 ≥60 lm/W),
--         incandescent ban (DMRE, 2016)

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Tanzania';
-- Source: TBS EAS 776 (EAC/SADC dual alignment)

UPDATE meps_country_data SET
  lighting_led_min = 80,
  lighting_incandescent_banned = TRUE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Tunisia';
-- Source: ANME Programme d''Efficacité Énergétique (2021), OPS03 research

UPDATE meps_country_data SET
  lighting_led_min = 70,
  lighting_incandescent_banned = FALSE,
  lighting_cfl_banned = FALSE
WHERE country_name = 'Uganda';
-- Source: UEDCL/REA EAC EAS 776 alignment

-- Step 3: Verify
SELECT
  country_name,
  lighting_led_min,
  lighting_t8_min,
  lighting_street_min,
  lighting_incandescent_banned,
  lighting_cfl_banned
FROM meps_country_data
WHERE lighting_led_min IS NOT NULL
ORDER BY country_name;
