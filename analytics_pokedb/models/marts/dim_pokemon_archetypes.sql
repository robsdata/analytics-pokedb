
-- models/marts/dim_pokemon_archetypes.sql

with pokemon_stats as (
    -- We select from our staging model, not the raw source.
    select
        pokedex_number,
        name,
        attack,
        defense,
        special_attack,
        special_defense,
        health_points,
        speed
    from {{ ref('stg_pokemon') }}
),

pokemon_percentiles as (
    -- We use window functions to calculate the percentile rank for each stat.
    -- A value of 0.8 means the Pokémon is in the 80th percentile for that stat.
    select
        *,
        percent_rank() over (order by attack) as attack_percentile,
        percent_rank() over (order by defense) as defense_percentile,
        percent_rank() over (order by special_attack) as sp_attack_percentile,
        percent_rank() over (order by special_defense) as sp_defense_percentile,
        percent_rank() over (order by health_points) as hp_percentile,
        percent_rank() over (order by speed) as speed_percentile
    from pokemon_stats
),

archetype_definitions as (
    -- We use a CASE WHEN statement to assign an archetype based on the percentiles.
    -- This logic can be as simple or complex as we want.
    select
        pokedex_number,
        name,
        case
            when hp_percentile >= 0.8 and defense_percentile >= 0.8 then 'Tank'
            when (attack_percentile >= 0.8 or sp_attack_percentile >= 0.8)
                and (defense_percentile <= 0.2 and hp_percentile <= 0.2) then 'Glass Cannon'
            when speed_percentile >= 0.8 and (attack_percentile >= 0.6 or sp_attack_percentile >= 0.6) then 'Fast Sweeper'
            when defense_percentile >= 0.8 and sp_defense_percentile >= 0.8 then 'Defensive Wall'
            else 'Balanced'
        end as archetype
    from pokemon_percentiles
)

select * from archetype_definitions